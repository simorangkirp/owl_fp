import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/error/exception.handler.dart';
import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/usecase/auth/login.usecase.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;
  LoginController(this._loginUseCase);
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

  void login(String username, String token) {
    storage.saveIsLoggedIn(true);
    storage.saveUsername(username);
    storage.saveToken(token);
  }

  Future<void> onLogin() async {
    try {
      var res = await _loginUseCase.execute(unCtrl.text, pwCtrl.text);
      if (res) {
        var box = StorageService();
        box.saveIsLoggedIn(res);
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
    // Delay sejenak supaya transition-nya smooth dan tidak konflik build
    Future.delayed(Duration(milliseconds: 100), () {
      final isLoggedIn = box.isLoggedIn;
      if (isLoggedIn) {
        Get.offAllNamed('/home'); // Redirect langsung
      } else {
        Get.offAllNamed('/login');
      }
    });
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
