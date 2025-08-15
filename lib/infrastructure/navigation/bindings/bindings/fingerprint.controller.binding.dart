import 'package:get/get.dart';

import '/presentation/ui/fingerprint/controllers/fingerprint.controller.dart';
import '/domain/usecase/fingerprint/get.btstats.opt.usecase.dart';
import '/domain/usecase/fingerprint/get.dt.opt.usecase.dart';
import '/domain/usecase/fingerprint/get.setting.options.dart';
import '/domain/usecase/fingerprint/get.uploaddown.opt.usecase.dart';
import '/domain/usecase/masterdata/find.karyawan.usecase.dart';
import '/domain/usecase/fingerprint/insert.template.dart';
import '/data/dal/daos/fingerprint/fp.repoimpl.dart';
import '/data/dal/daos/masterdata/master.repoimpl.dart';

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
    Get.lazyPut<FingerprintController>(
      () => FingerprintController(
        Get.find<FindKaryawanTupleUseCase>(),
        Get.find<GetUploadDownloadOptionsUseCase>(),
        Get.find<GetSettingOptionsUseCase>(),
        Get.find<GetDTOptUseCase>(),
        Get.find<GetBtstatsOptUseCase>(),
        Get.find<InsertTemplateUseCase>(),
      ),
    );
  }
}
