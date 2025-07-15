import 'package:get/get.dart';

import '../../../presentation/ui/help/controllers/help.controller.dart';

class HelpControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpController>(
      () => HelpController(),
    );
  }
}
