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
      await _retryStep(onLogin, "Login");

      // 🔹 Step 2: Profile
      DialogHelper.showLoadingStep(
        2,
        "Ambil Profile",
        // "Mengambil data profil pengguna...",
        3,
      );
      await _retryStep(getProfileApi, "Ambil Profile");

      // 🔹 Step 3: Master Data
      DialogHelper.showLoadingStep(
        3,
        "Sinkronisasi Master Data",
        // "Mengambil & menyimpan master data...",
        3,
      );
      await _retryStep(onLoginGetMasterData, "Sinkronisasi Master Data");

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
      if (Get.isDialogOpen == true) {
        Get.back(closeOverlays: true);
      }

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

  /// 🔹 Helper buat retry otomatis kalau DioError timeout (v4)
  Future<void> _retryStep(Future<void> Function() step, String stepName) async {
    int retry = 0;
    const maxRetry = 2;

    while (true) {
      try {
        await step();
        break; // ✅ sukses
      } on DioError catch (e) {
        if ((e.type == DioErrorType.receiveTimeout ||
                e.type == DioErrorType.connectTimeout ||
                e.type == DioErrorType.sendTimeout) &&
            retry < maxRetry) {
          retry++;
          debugPrint("⏳ $stepName timeout, coba ulang ($retry/$maxRetry)...");
          await Future.delayed(const Duration(seconds: 1));
          continue;
        }
        rethrow; // ❌ error lain -> lempar
      }
    }
  }

  Future<void> onLogin() async {
    isSync.value = true;
    storage.saveUsername(unCtrl.text);
    storage.savePwd(pwCtrl.text);
    try {
      await _loginUseCase.execute(unCtrl.text, pwCtrl.text);
    } catch (e) {
      log("Login gagal: $e");
      rethrow; // biar ditangani di snackbar loginDialog
    }
    isSync.value = false;
  }

  Future<void> onReLogin() async {
    await _loginUseCase.execute(
      storage.username ?? "",
      storage.pwd ?? "",
    );
    isSync.value = true;
  }

  Future<void> getProfileApi() async {
    await _profileUseCase.execute();
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
