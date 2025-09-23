import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/dal/services/get.storage.dart';
import '../../login/controllers/login.controller.dart';

class ChangeUserController extends GetxController {
  var box = StorageService.instance;

  /// Text Controller
  var urlCtrl = TextEditingController();
  var unCtrl = TextEditingController();
  var pwCtrl = TextEditingController();

  /// boolean Variables
  var isShown = false.obs;
  var enaBtn = false.obs;
  var isObs = true.obs;

  /// Async Function Lists
  Future<void> onChangeUser() async {
    final loginCtrl = Get.find<LoginController>();
    loginCtrl.unCtrl.text = unCtrl.text;
    loginCtrl.pwCtrl.text = pwCtrl.text;
    await loginCtrl.loginDialog();
  }

  @override
  Future<void> onInit() async {
    urlCtrl.text = box.bUrl ?? "";
    pwCtrl.text = box.pwd ?? "";
    unCtrl.text = box.username ?? "";
    if (urlCtrl.text != "" && pwCtrl.text != "") {
      enaBtn.value = true;
    }
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
