import 'package:owl_fp_newer/core/resources/data.state.dart';
import 'package:owl_fp_newer/domain/entity/karyawan.entity.dart';

abstract class MasterDataRepository {
  Future<DataState> getKaryawan();
  Future<List<KaryawanEntity>?> getKaryawanTuple(String args);

  Future<String?> getLogMaster(String args);
}
