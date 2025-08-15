import 'package:get/get.dart';

import '/presentation/ui/splash/controllers/splash.controller.dart';

class SplashControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
