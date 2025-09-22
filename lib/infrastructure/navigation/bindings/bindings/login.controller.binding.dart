import 'package:get/get.dart';
import 'package:owl_fp/domain/usecase/auth/login.usecase.dart';
import 'package:owl_fp/domain/usecase/auth/profile.usecase.dart';
import 'package:owl_fp/domain/usecase/auth/get.master.data.dart';

import '/presentation/ui/login/controllers/login.controller.dart';
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
      () => OnLoginMasterData(Get.find<AuthRepositoryImpl>()),
    );
    // Get.lazyPut(
    //   () => SyncMasterDataUseCase(Get.find<MasterRepositoryImpl>()),
    // );
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<LoginUseCase>(),
        Get.find<ProfileUseCase>(),
        Get.find<OnLoginMasterData>(),
        // Get.find<SyncMasterDataUseCase>(),
      ),
    );
  }
}
