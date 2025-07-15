import 'package:get/get.dart';

import '../../../presentation/ui/sampletext/controllers/sampletext.controller.dart';

class SampletextControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SampletextController>(
      () => SampletextController(),
    );
  }
}
