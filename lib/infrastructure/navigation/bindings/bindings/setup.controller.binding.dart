import 'package:get/get.dart';

import '/presentation/ui/setup/controllers/setup.controller.dart';

class SetupControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetupController>(
      () => SetupController(),
    );
  }
}
