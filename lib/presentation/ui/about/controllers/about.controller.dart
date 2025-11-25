import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ota_update/ota_update.dart';
import 'package:owl_fp_newer/core/resources/data.state.dart';
import 'package:owl_fp_newer/core/resources/utils.dart';
import 'package:owl_fp_newer/data/dal/services/get.storage.dart';
// import 'package:owl_fp_newer/domain/usecase/about/download.apk.uc.dart';
import 'package:owl_fp_newer/domain/usecase/about/get.apkver.uc.dart';
import 'package:owl_fp_newer/presentation/ui/common/controller/permission.controller.dart';
import 'package:owl_fp_newer/presentation/ui/login/controllers/login.controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutController extends GetxController {
  final GetAppVersionUseCase _getAppVerUseCase;
  // final DownloadLatestVerUseCase _downloadLatestAppUseCase;

  AboutController(
    this._getAppVerUseCase,
    // this._downloadLatestAppUseCase,
  );

  final version = "".obs;
  final buildNumber = "".obs;
  final isLoading = false.obs;
  final apiResult = Rx<DataState?>(null);

  final updateUrl = "".obs; // tempat nyimpen URL APK dari server
  final progress = 0.0.obs;

  final storage = Get.find<StorageService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    version.value = info.version;
    buildNumber.value = info.buildNumber;
  }

  // ============================================================
  // Update Latest Application
  // ============================================================

  Future<void> startOtaUpdate() async {
    if (updateUrl.value.isEmpty) {
      Get.snackbar("Error", "URL update belum tersedia");
      return;
    }

    final permCtrl = Get.find<PermissionController>();

    // 🔥 1. Pastikan permission OTA lengkap sebelum mulai OTA
    final ok = await permCtrl.checkOtaPermission();
    if (!ok) {
      return;
    }

    try {
      OtaUpdate()
          .execute(
        updateUrl.value,
        destinationFilename: "update.apk",
      )
          .listen((event) async {
        // 🔄 Status: DOWNLOADING
        if (event.status == OtaStatus.DOWNLOADING) {
          final raw = event.value ?? '0';
          final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
          final parsed = double.tryParse(cleaned) ?? 0.0;
          progress.value = parsed;
        }

        // 🔄 Status: INSTALLING
        else if (event.status == OtaStatus.INSTALLING) {
          log("Installing...");
        }

        // ❌ Status: PERMISSION_NOT_GRANTED_ERROR
        else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
          log("❌ Permission OTA belum granted, mencoba request ulang...");

          final granted = await permCtrl.checkOtaPermission();

          if (!granted) {
            Get.snackbar(
              "Izin Diperlukan",
              "Akses Storage & Install Aplikasi wajib diizinkan untuk update.",
            );
            return;
          }

          // Jika user sudah grant → restart OTA (auto)
          startOtaUpdate();
        }

        // ❌ Status: INTERNAL_ERROR
        else if (event.status == OtaStatus.INTERNAL_ERROR) {
          Get.snackbar(
            "Update Gagal",
            "Terjadi error internal. Coba ulangi beberapa saat lagi.",
          );
        }
      });
    } catch (e) {
      Get.snackbar("Update Error", "Gagal update: $e");
    }
  }

  // ============================================================
  // GET APP VERSION
  // ============================================================

  Future<void> getAppVer() async {
    isLoading.value = true;
    _showLoadingDialog(); // <-- pastikan ini ada (sudah ditambahkan)

    final expired = await isTokenExpired(storage.expToken);

    late DataState result;

    if (!expired) {
      result = await _getAppVerUseCase.execute();
    } else {
      final loginCtrl = Get.find<LoginController>();
      await loginCtrl.onReLogin();
      result = await _getAppVerUseCase.execute();
    }

    apiResult.value = result;

    if (Get.isDialogOpen == true) Get.back(); // close loading dialog
    isLoading.value = false;

    if (result is DataSuccess) {
      final latestVersion =
          result.data["result"]["app_version"].toString().trim();

      updateUrl.value = result.data["result"]["url"].toString().trim();

      if (_compareVersion(version.value, latestVersion)) {
        // versi local < versi server → tampilkan konfirmasi update
        _showUpdateConfirmDialog(latestVersion);
      } else {
        // up-to-date
        _showSuccessDialog(result);
      }
    } else {
      _showErrorDialog(result as DataError);
    }
  }

  // Versi lokal < versi server ?
  bool _compareVersion(String local, String server) {
    try {
      final l = local.split('.').map(int.parse).toList();
      final s = server.split('.').map(int.parse).toList();

      final maxLen = (l.length > s.length) ? l.length : s.length;
      for (int i = 0; i < maxLen; i++) {
        final lv = i < l.length ? l[i] : 0;
        final sv = i < s.length ? s[i] : 0;
        if (lv < sv) return true;
        if (lv > sv) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // DIALOG KONFIRMASI UPDATE
  // ============================================================

  void _showUpdateConfirmDialog(String latest) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.system_update, size: 48, color: Colors.blue),
              SizedBox(height: 16.h),
              Text(
                "Update Tersedia!",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Versi terbaru tersedia: $latest\n\nApakah Anda ingin mendownload pembaruan?",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Nanti"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      startOtaUpdate(); // ✅ OTA update
                      _showOtaProgressDialog(); // tampilkan dialog progress OTA
                    },
                    child: const Text("Download"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DOWNLOAD DIALOGS
  // ============================================================

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Versi Terbaru',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24.h),
              const CircularProgressIndicator(),
              SizedBox(height: 12.h),
              const Text('Sedang memeriksa versi terbaru aplikasi.')
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showOtaProgressDialog() {
    Get.dialog(
      Obx(
        () => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Memperbarui Aplikasi...",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: progress.value / 100,
                ),
                const SizedBox(height: 12),
                Text("${progress.value.toStringAsFixed(0)}%"),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ============================================================
  // EXISTING SUCCESS & ERROR DIALOGS (tetap dipakai)
  // ============================================================

  void _showSuccessDialog(DataSuccess result) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 48, color: Colors.green),
              SizedBox(height: 16.h),
              Text(
                "Versi Aplikasi",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Text("Versi terbaru: ${result.data["result"]["app_version"]}"),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("Tutup"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(DataError result) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                "Gagal Mendapatkan Versi",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Text(result.error.toString()),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("Tutup"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
