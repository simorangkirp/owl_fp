import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../data/dal/services/get.storage.dart';

class SplashController extends GetxController {
  final StorageService box = Get.find<StorageService>();
  RxBool isLogin = false.obs;

  Future<void> validate() async {
    // kalau mau splash kelihatan sebentar tambahin delay
    await Future.delayed(const Duration(seconds: 2));

    if (box.isLoggedIn) {
      Get.offAllNamed('/home');
      // Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // tunggu sampai build pertama selesai, baru navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await validate();
    });
  }
}
