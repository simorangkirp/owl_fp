import 'package:owl_fp/core/resources/data.state.dart';

import '../../repository/master.repo.dart';

class GetSettingOptionsUseCase {
  final MasterDataRepository repository;

  GetSettingOptionsUseCase(this.repository);

  Future<DataState> execute() {
    return repository.getKaryawan();
  }
}
