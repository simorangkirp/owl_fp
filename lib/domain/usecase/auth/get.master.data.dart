import 'package:owl_fp_newer/core/resources/data.state.dart';

import '../../repository/auth.repo.dart';

class OnLoginMasterData {
  final AuthRepository repository;

  OnLoginMasterData(this.repository);

  Future<DataState> execute() {
    return repository.onLoginMasterDataRepo();
  }
}
