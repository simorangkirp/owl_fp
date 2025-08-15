import 'package:get/get.dart';
import 'package:owl_fp/domain/usecase/profile/getuser.usecase.dart';

import '/presentation/ui/profile/controllers/profile.controller.dart';
import '/domain/usecase/masterdata/master.usecase.dart';
import '/data/dal/daos/profile/profile.repoimpl.dart';

class ProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
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
