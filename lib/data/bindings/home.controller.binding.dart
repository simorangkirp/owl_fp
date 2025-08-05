import 'package:get/get.dart';

import '../../../presentation/ui/home/controllers/home.controller.dart';
import '../../domain/usecase/masterdata/master.usecase.dart';
import '../../domain/usecase/profile/getuser.usecase.dart';
import '../../presentation/ui/profile/controllers/profile.controller.dart';
import '../dal/daos/profile/profile.repoimpl.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GetUserUseCase(Get.find<ProfileRepositoryImpl>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<GetUserUseCase>(),
        Get.find<SyncMasterDataUseCase>(),
      ),
    );
  }
}
