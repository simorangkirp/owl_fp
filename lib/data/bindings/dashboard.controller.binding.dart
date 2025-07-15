import 'package:get/get.dart';

import '../../../presentation/ui/dashboard/controllers/dashboard.controller.dart';

class DashboardControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
  }
}
