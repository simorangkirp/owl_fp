import 'package:get/get.dart';

import '/presentation/ui/home/controllers/home.controller.dart';
import '/domain/usecase/masterdata/master.usecase.dart';
import '/domain/usecase/profile/getuser.usecase.dart';
import '/presentation/ui/profile/controllers/profile.controller.dart';
import '/data/dal/daos/masterdata/master.repoimpl.dart';
import '/data/dal/daos/profile/profile.repoimpl.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GetUserUseCase(Get.find<ProfileRepositoryImpl>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<SyncMasterDataUseCase>(
      () => SyncMasterDataUseCase(Get.find<MasterRepositoryImpl>()),
    );
    Get.lazyPut<GetUserUseCase>(
      () => GetUserUseCase(Get.find<ProfileRepositoryImpl>()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<GetUserUseCase>(),
        Get.find<SyncMasterDataUseCase>(),
      ),
    );
  }
}
