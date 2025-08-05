import 'package:owl_fp/domain/entity/karyawan.entity.dart';
import 'package:owl_fp/domain/repository/master.repo.dart';

import '../../services/apis/master.api.dart';
import '../../services/db/master.db.dart';

class MasterRepositoryImpl implements MasterDataRepository {
  final MasterLocalDataSource localDataSource;
  final MasterRemoteDataSource remoteDataSource;

  MasterRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<KaryawanEntity>?> getKaryawan() async {
    var ret = <KaryawanEntity>[];
    final response = await remoteDataSource.remoteKaryawan();
    if (response != null) {
      for (var el in response) {
        ret.add(el.toEntity());
      }
      await localDataSource.deleteKaryawan();
      await localDataSource.syncKaryawan(response);
    }
    return ret;
  }
}
