import 'package:get/get.dart';

import '/presentation/template/controllers/template.controller.dart';

class TemplateControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateController>(
      () => TemplateController(),
    );
  }
}
