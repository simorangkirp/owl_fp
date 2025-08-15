import 'package:get/get.dart';

import '/domain/usecase/masterdata/find.karyawan.usecase.dart';
import '/presentation/ui/masterdata/controllers/masterdata.controller.dart';
import '/data/dal/daos/masterdata/master.repoimpl.dart';

class MasterdataControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FindKaryawanTupleUseCase(Get.find<MasterRepositoryImpl>()),
    );
    Get.lazyPut<MasterdataController>(
      () => MasterdataController(
        Get.find<FindKaryawanTupleUseCase>(),
      ),
    );
  }
}
