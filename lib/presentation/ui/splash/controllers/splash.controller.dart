import 'package:get/get.dart';

import '../../../../data/dal/services/get.storage.dart';

class SplashController extends GetxController {
  final StorageService box = Get.find<StorageService>();
  RxBool isLogin = false.obs;

  Future<void> validate() async {
// Delay biar animasi splash keliatan
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
  }
}
