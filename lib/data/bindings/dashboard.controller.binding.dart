import 'package:get/get.dart';

import '../../../presentation/ui/dashboard/controllers/dashboard.controller.dart';
import '../../domain/usecase/dashboard/master.list.usecase.dart';

class DashboardControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<GetMasterHeaderUseCase>(),
      ),
    );
  }
}
