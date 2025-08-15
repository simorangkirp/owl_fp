import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/error/exception.handler.dart';
import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/usecase/auth/login.usecase.dart';
import '../../../../domain/usecase/auth/profile.usecase.dart';
import '../../../../domain/usecase/masterdata/master.usecase.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;
  final ProfileUseCase _profileUseCase;
  final SyncMasterDataUseCase _syncUseCase;
  LoginController(this._loginUseCase, this._profileUseCase, this._syncUseCase);
  final storage = Get.find<StorageService>();

  /// Text Controller
  var urlCtrl = TextEditingController();
  var unCtrl = TextEditingController();
  var pwCtrl = TextEditingController();

  /// String Variables
  var selectedType = "".obs;
  var selectedVer = "".obs;

  /// List Variables
  var listVer = <String>["v1", "v2"].obs;
  var listType = <String>["http", "https"].obs;

  /// boolean Variables
  var isShown = false.obs;
  var enaBtn = false.obs;
  var isObs = true.obs;

  /// Integers
  int _tapCount = 0;

  /// Timers
  Timer? _resetTimer;

  // Bool Args
  RxBool isLogin = false.obs;

  void displayUrl() {
    if (!isShown.value) {
      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(seconds: 1), () {
        _tapCount = 0;
      });

      _tapCount++;
      if (_tapCount >= 7) {
        isShown.value = true;
        _tapCount = 0;
        _resetTimer?.cancel();
      }
    }
  }

  void saveUrl() async {
    await storage.saveBUrl(urlCtrl.text);
    log(storage.bUrl ?? "Tidak Tersimpan");
    isShown.value = false;
    Get.snackbar(
      '',
      'Berhasil Tersimpan.',
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2), // Supaya tidak hilang otomatis
      margin: const EdgeInsets.all(12),
    );
    Future.delayed(const Duration(seconds: 1));
  }

  Future<void> loginDialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),
                const CircularProgressIndicator(),
                SizedBox(height: 12.h),
                Text('Sedang mencoba masuk kedalam aplikasi.')
                // Text("Menemukan ${deviceFound.value.toString()} perangkat.")
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    });
    // Pantau kondisi isRegistered dan tutup dialog jika true
    ever(isLogin, (val) async {
      if (val == true && Get.isDialogOpen == true) {
        Get.back(); // menutup dialog
        Get.snackbar(
          '',
          "Berhasil Login!",
          titleText: const SizedBox.shrink(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 2), // Supaya tidak hilang otomatis
          margin: const EdgeInsets.all(12),
        );
        Get.toNamed('/home');
      }
    });
  }

  Future<void> getProfileApi() async {
    try {
      await _profileUseCase.execute();
      isLogin.value = true;
    } on ExceptionHandler catch (e) {
      Get.snackbar(
        '',
        e.toString(),
        titleText: const SizedBox.shrink(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2), // Supaya tidak hilang otomatis
        margin: const EdgeInsets.all(12),
      );
    }
  }

  Future<void> onLogin() async {
    try {
      var res = await _loginUseCase.execute(unCtrl.text, pwCtrl.text);
      if (res) {
        // await _syncUseCase.execute();
        storage.saveUsername(unCtrl.text);
        storage.saveIsLoggedIn(res);
      }
    } on ExceptionHandler catch (e) {
      Get.snackbar(
        '',
        e.toString(),
        titleText: const SizedBox.shrink(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2), // Supaya tidak hilang otomatis
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  void onInit() {
    var box = StorageService();
    urlCtrl.text = box.bUrl ?? "";
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }
}
