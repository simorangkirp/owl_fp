import 'package:owl_fp/domain/entity/karyawan.entity.dart';

import '../../repository/master.repo.dart';

class SyncMasterDataUseCase {
  final MasterDataRepository repository;

  SyncMasterDataUseCase(this.repository);

  Future<List<KaryawanEntity>?> execute() {
    return repository.getKaryawan();
  }
}
