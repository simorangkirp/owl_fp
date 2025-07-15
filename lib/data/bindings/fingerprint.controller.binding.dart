import 'package:get/get.dart';

import '../../../presentation/ui/fingerprint/controllers/fingerprint.controller.dart';

class FingerprintControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FingerprintController>(
      () => FingerprintController(),
    );
  }
}
