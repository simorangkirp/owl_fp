import 'package:get/get.dart';

import '../../../../presentation/ui/change_user/controllers/change_user.controller.dart';

class ChangeUserControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeUserController>(
      () => ChangeUserController(),
    );
  }
}
