import 'package:get/get.dart';

import 'package:owl_fp_newer/domain/usecase/fingerprint/delete.template.dart';
import 'package:owl_fp_newer/presentation/ui/common/controller/permission.controller.dart';

import '/domain/usecase/fingerprint/get.admin.ddoptlist.dart';
import '/data/dal/daos/fingerprint/fp.repoimpl.dart';
import '/data/dal/daos/masterdata/master.repoimpl.dart';
import '/domain/usecase/fingerprint/get.btstats.opt.usecase.dart';
import '/domain/usecase/fingerprint/get.dt.opt.usecase.dart';
import '/domain/usecase/fingerprint/get.mst.admin.dart';
import '/domain/usecase/fingerprint/get.setting.options.dart';
import '/domain/usecase/fingerprint/get.template.dart';
import '/domain/usecase/fingerprint/get.uploaddown.opt.usecase.dart';
import '/domain/usecase/fingerprint/insert.template.dart';
import '/domain/usecase/fingerprint/send.template.dart';
import '/domain/usecase/fingerprint/sn.usecase.dart';
import '/domain/usecase/masterdata/find.karyawan.usecase.dart';
import '/presentation/ui/fingerprint/controllers/fingerprint.controller.dart';

// import '../../../../domain/usecase/fingerprint/upload.tofinger.dart';

class FingerprintControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FindKaryawanTupleUseCase(Get.find<MasterRepositoryImpl>()),
    );
    Get.lazyPut(
      () => GetUploadDownloadOptionsUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => GetAdminOptionsUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => GetSettingOptionsUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => GetDTOptUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => GetBtstatsOptUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => InsertTemplateUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => DeleteTemplateUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => GetSNListUsecase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => GetDataTemplate(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => SendTemplateUseCase(Get.find<FingerprintRepoImpl>()),
    );
    Get.lazyPut(
      () => GetMasterAdminUsecase(Get.find<FingerprintRepoImpl>()),
    );
    // Tambahkan controller PermissionController
    Get.lazyPut<PermissionController>(
      () => PermissionController(),
    );
    // Get.lazyPut(
    //   () => SendTemplateToDeviceUsecase(Get.find<FingerprintRepoImpl>()),
    // );
    Get.lazyPut<FingerprintController>(
      () => FingerprintController(
        Get.find<FindKaryawanTupleUseCase>(),
        Get.find<GetUploadDownloadOptionsUseCase>(),
        Get.find<GetAdminOptionsUseCase>(),
        Get.find<GetSettingOptionsUseCase>(),
        Get.find<GetDTOptUseCase>(),
        Get.find<GetBtstatsOptUseCase>(),
        Get.find<InsertTemplateUseCase>(),
        Get.find<DeleteTemplateUseCase>(),
        Get.find<GetSNListUsecase>(),
        Get.find<GetDataTemplate>(),
        Get.find<SendTemplateUseCase>(),
        Get.find<GetMasterAdminUsecase>(),
        // Get.find<SendTemplateToDeviceUsecase>(),
        // Get.find<TemplateController>(),
      ),
    );
  }
}
