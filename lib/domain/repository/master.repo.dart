import 'package:owl_fp/core/resources/data.state.dart';
import 'package:owl_fp/domain/entity/karyawan.entity.dart';

abstract class MasterDataRepository {
  Future<DataState> getKaryawan();
  Future<List<KaryawanEntity>?> getKaryawanTuple(String args);
}
