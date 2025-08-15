import 'package:get/get.dart';

import '/presentation/ui/theme/controllers/theme.controller.dart';

class ThemeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(
      () => ThemeController(),
    );
  }
}
