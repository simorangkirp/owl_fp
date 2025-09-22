import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/resources/utils.dart';
import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/usecase/auth/get.master.data.dart';
import '../../../../domain/usecase/auth/login.usecase.dart';
import '../../../../domain/usecase/auth/profile.usecase.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;
  final ProfileUseCase _profileUseCase;
  final OnLoginMasterData _onloginMasterUsecase;

  LoginController(
    this._loginUseCase,
    this._profileUseCase,
    this._onloginMasterUsecase,
  );

  final storage = Get.find<StorageService>();

  // 🔹 Text Controllers
  final urlCtrl = TextEditingController();
  final unCtrl = TextEditingController();
  final pwCtrl = TextEditingController();

  // 🔹 Observable Variables
  final selectedType = "".obs;
  final selectedVer = "".obs;
  final loginMessage = "".obs;
  final currentStep = 0.obs;
  final totalStep = 3;

  final listVer = <String>["v1", "v2"].obs;
  final listType = <String>["http", "https"].obs;

  final isShown = false.obs;
  final enaBtn = false.obs;
  final isObs = true.obs;

  final isLogin = false.obs;
  final isSync = false.obs;

  // 🔹 Private Vars
  int _tapCount = 0;
  Timer? _resetTimer;

  // ==============================
  // URL Section
  // ==============================
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

  Future<void> saveUrl() async {
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
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ==============================
  // Login Flow
  // ==============================
  Future<void> loginDialog() async {
    isLogin.value = false;
    isSync.value = false;

    try {
      // 🔹 Step 1: Login
      DialogHelper.showLoadingStep(
        1,
        "Login",
        // "Sedang mencoba masuk ke aplikasi...",
        3,
      );
      await retryStep(onLogin, "Login");

      // 🔹 Step 2: Profile
      DialogHelper.showLoadingStep(
        2,
        "Ambil Profile",
        // "Mengambil data profil pengguna...",
        3,
      );
      await retryStep(getProfileApi, "Ambil Profile");

      // 🔹 Step 3: Master Data
      DialogHelper.showLoadingStep(
        3,
        "Sinkronisasi Master Data",
        // "Mengambil & menyimpan master data...",
        3,
      );
      await retryStep(onLoginGetMasterData, "Sinkronisasi Master Data");

      // 🔹 Tutup dialog jika sudah selesai
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // 🔹 Redirect ke home jika login berhasil
      if (isLogin.value) {
        Get.offAllNamed('/home');

        if (loginMessage.isNotEmpty) {
          Get.snackbar(
            '',
            loginMessage.value,
            titleText: const SizedBox.shrink(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(12),
          );
        }
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();

      Get.snackbar(
        "Login Gagal",
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> onLogin() async {
    isSync.value = true;

    // final res = await _loginUseCase.execute(unCtrl.text, pwCtrl.text);
    await _loginUseCase.execute(unCtrl.text, pwCtrl.text);

    // DialogHelper.handleApiResult(
    //   res,
    //   successMessage: "Login berhasil, selamat datang!",
    //   onSuccess: (data) {
    //     if (data is Map<String, dynamic> && data['error'] != false) {
    //       storage.saveUsername(unCtrl.text);
    //       storage.savePwd(pwCtrl.text);
    //       storage.saveIsLoggedIn(true);
    //     }
    //   },
    // );

    isSync.value = false;
  }

  Future<void> onReLogin() async {
    final res = await _loginUseCase.execute(
      storage.username ?? "",
      storage.pwd ?? "",
    );

    DialogHelper.handleApiResult(
      res,
      successMessage: "Login ulang berhasil!",
    );

    isSync.value = true;
  }

  Future<void> getProfileApi() async {
    // final res = await _profileUseCase.execute();
    await _profileUseCase.execute();

    // DialogHelper.handleApiResult(
    //   res,
    //   successMessage: "Profile berhasil diambil",
    //   onSuccess: (_) => isSync.value = true,
    // );
  }

  Future<void> onLoginGetMasterData() async {
    final res = await _onloginMasterUsecase.execute();

    DialogHelper.handleApiResult(
      res,
      successMessage: "Login berhasil.",
      onSuccess: (_) {
        isLogin.value = true;

        // close loading dialog & redirect setelah master data selesai
        if (Get.isDialogOpen == true) {
          Get.back();
          Get.offAllNamed('/home');
        }
      },
    );
  }

  // ==============================
  // Lifecycle
  // ==============================
  @override
  void onInit() {
    urlCtrl.text = storage.bUrl ?? "";
    super.onInit();
  }

  @override
  void onClose() {
    urlCtrl.dispose();
    unCtrl.dispose();
    pwCtrl.dispose();
    _resetTimer?.cancel();
    super.onClose();
  }
}
