import 'package:get/get.dart';

import '../../../presentation/ui/fingerprint/controllers/fingerprint.controller.dart';
import '../../domain/usecase/masterdata/find.karyawan.usecase.dart';
import '../dal/daos/masterdata/master.repoimpl.dart';

class FingerprintControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FindKaryawanTupleUseCase(Get.find<MasterRepositoryImpl>()),
    );
    Get.lazyPut<FingerprintController>(
      () => FingerprintController(
        Get.find<FindKaryawanTupleUseCase>(),
      ),
    );
  }
}
