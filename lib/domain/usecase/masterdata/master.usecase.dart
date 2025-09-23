import 'package:owl_fp_newer/core/resources/data.state.dart';

import '../../repository/master.repo.dart';

class SyncMasterDataUseCase {
  final MasterDataRepository repository;

  SyncMasterDataUseCase(this.repository);

  Future<DataState> execute() {
    return repository.getKaryawan();
  }
}
