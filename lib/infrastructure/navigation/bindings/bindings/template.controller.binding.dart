import 'package:get/get.dart';
import 'package:owl_fp/data/dal/daos/template/template.repoimpl.dart';
import 'package:owl_fp/presentation/ui/template/controllers/template.controller.dart';

import 'package:owl_fp/domain/usecase/template/get.fptemp.usecase.dart';
import 'package:owl_fp/domain/usecase/template/get.karyawan.usecase.dart';
import 'package:owl_fp/domain/usecase/template/get.sn.usecase.dart';

class TemplateControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GetSNListUsecase(Get.find<TemplateRepoImpl>()),
    );
    Get.lazyPut(
      () => KaryawanFPTemplateUsecase(Get.find<TemplateRepoImpl>()),
    );
    Get.lazyPut(
      () => GetKaryawanUseCase(Get.find<TemplateRepoImpl>()),
    );
    Get.lazyPut<TemplateController>(
      () => TemplateController(
        Get.find<GetSNListUsecase>(),
        Get.find<KaryawanFPTemplateUsecase>(),
        Get.find<GetKaryawanUseCase>(),
      ),
    );
  }
}
