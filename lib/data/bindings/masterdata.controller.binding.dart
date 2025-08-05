import 'package:get/get.dart';

import '../../presentation/ui/masterdata/controllers/masterdata.controller.dart';

class MasterdataControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterdataController>(
      () => MasterdataController(),
    );
  }
}
