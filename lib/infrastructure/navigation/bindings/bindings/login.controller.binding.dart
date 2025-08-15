import 'package:get/get.dart';
import 'package:owl_fp/data/dal/daos/masterdata/master.repoimpl.dart';
import 'package:owl_fp/domain/usecase/auth/login.usecase.dart';
import 'package:owl_fp/domain/usecase/auth/profile.usecase.dart';

import '/presentation/ui/login/controllers/login.controller.dart';
import '/domain/usecase/masterdata/master.usecase.dart';
import '/data/dal/daos/auth/auth.repoimpl.dart';

class LoginControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginUseCase(Get.find<AuthRepositoryImpl>()),
    );
    Get.lazyPut(
      () => ProfileUseCase(Get.find<AuthRepositoryImpl>()),
    );
    Get.lazyPut(
      () => SyncMasterDataUseCase(Get.find<MasterRepositoryImpl>()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<LoginUseCase>(),
        Get.find<ProfileUseCase>(),
        Get.find<SyncMasterDataUseCase>(),
      ),
    );
  }
}
