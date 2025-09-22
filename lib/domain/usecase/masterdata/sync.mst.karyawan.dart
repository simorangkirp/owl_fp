import 'package:owl_fp/core/resources/data.state.dart';

import '../../repository/master.repo.dart';

class OnSyncMstKaryawanUsecase {
  final MasterDataRepository repository;

  OnSyncMstKaryawanUsecase(this.repository);

  Future<DataState> execute() {
    return repository.getKaryawan();
  }
}
