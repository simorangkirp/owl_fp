import 'package:owl_fp/domain/entity/karyawan.entity.dart';

abstract class MasterDataRepository {
  Future<List<KaryawanEntity>?> getKaryawan();
}
