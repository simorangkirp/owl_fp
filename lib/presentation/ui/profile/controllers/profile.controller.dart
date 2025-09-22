import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:owl_fp/core/resources/data.state.dart';
import 'package:owl_fp/domain/entity/profile.entity.dart';

import '../../../../core/resources/utils.dart';
import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/usecase/masterdata/master.usecase.dart';
import '../../../../domain/usecase/profile/getuser.usecase.dart';
import '../../login/controllers/login.controller.dart';

class ProfileController extends GetxController {
  // Dependencies
  final GetUserUseCase _profileUseCase;
  final SyncMasterDataUseCase _syncMDUseCase;
  final StorageService storage = Get.find<StorageService>();

  ProfileController(this._profileUseCase, this._syncMDUseCase);

  // State
  final Rxn<ProfileEntity> users = Rxn<ProfileEntity>();
  final RxString ip = "".obs;
  final RxBool isDone = false.obs;

  late DataState<dynamic>? res;
  bool tokenSts = false;

  // --- Public Methods ---

  Future<void> getUser() async {
    try {
      final res = await _profileUseCase.execute();
      users.value = res;
    } catch (e, s) {
      log("getUser error: $e", stackTrace: s);
    }
  }

  Future<void> _checkToken() async {
    tokenSts = await isTokenExpired(storage.expToken);
  }

  Future<void> exeSync() async {
    res = await _syncMDUseCase.execute();
  }

  Future<void> onRelog() async {
    final loginCtrl = Get.find<LoginController>();
    await loginCtrl.onReLogin();
  }

  Future<void> syncMD() async {
    // _showSyncDialog();

    // Tutup dialog otomatis setelah proses selesai
    // ever(isDone, (done) {
    //   if (done == true && Get.isDialogOpen == true) {
    //     Get.back();
    //   }
    // });

    try {
      // 🔹 Step 1: Check Token Valid
      DialogHelper.showLoadingStep(
        1,
        "Validasi Login",
        // "Sedang mencoba masuk ke aplikasi...",
        2,
      );
      await _checkToken();

      if (!tokenSts) {
        log("Token valid, langsung sinkronisasi...");
        // 🔹 Step 2: Profile
        DialogHelper.showLoadingStep(
          2,
          "Sinkronisasi Master Data!",
          // "Mengambil data profil pengguna...",
          2,
        );
        await retryStep(exeSync, "Sinkronisasi Master Data!");
      } else {
        log("Token expired, relogin dulu...");
        DialogHelper.showLoadingStep(
          1,
          "Validasi ulang login!",
          // "Mengambil data profil pengguna...",
          2,
        );
        await retryStep(onRelog, "Re-login!");

        DialogHelper.showLoadingStep(
          2,
          "Sinkronisasi Master Data!",
          // "Mengambil data profil pengguna...",
          2,
        );
        await retryStep(exeSync, "Sinkronisasi Master Data!");
      }

      // 🔹 Tutup dialog jika sudah selesai
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (res?.data["error"] == false) {
        showSnackBar("Sinkronisasi Berhasil!");
      } else {
        showSnackBar("Sinkronisasi Gagal!");
      }
    } catch (e, s) {
      log("syncMD error: $e", stackTrace: s);
      showSnackBar("Terjadi kesalahan sinkronisasi.");
    } finally {
      isDone.value = true;
    }
  }

  Future<void> confirmDialog() async {
    Get.dialog(
      AlertDialog(
        titlePadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
        actionsPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
        title: _buildDialogTitle("Sinkronisasi Master Data"),
        content: const Text("Apa anda yakin mau sinkronisasi Master Data?"),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              isDone.value = false;
              Get.back();
              syncMD();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Future<void> logOut() async {
    await storage.removeToken();
    await storage.saveIsLoggedIn(false);
    Get.offAllNamed('/login');
  }

  // --- Private Helpers ---

  void _showSyncDialog() {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTitle('Sinkron Master Data'),
              SizedBox(height: 24.h),
              const CircularProgressIndicator(),
              SizedBox(height: 12.h),
              const Text('Sinkronisasi master data.'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Text _buildDialogTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // --- Lifecycle ---

  @override
  Future<void> onInit() async {
    await getUser();
    ip.value = storage.bUrl ?? "";
    super.onInit();
  }
}
