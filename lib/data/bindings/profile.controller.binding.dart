import 'package:get/get.dart';

import '../../../presentation/ui/profile/controllers/profile.controller.dart';

class ProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
