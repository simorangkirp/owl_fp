import 'package:get/get.dart';
import 'package:owl_fp/domain/usecase/auth/login.usecase.dart';

import '../../../presentation/ui/login/controllers/login.controller.dart';
import '../dal/daos/auth/auth.repoimpl.dart';

class LoginControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginUseCase(Get.find<AuthRepositoryImpl>()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<LoginUseCase>(),
      ),
    );
  }
}
