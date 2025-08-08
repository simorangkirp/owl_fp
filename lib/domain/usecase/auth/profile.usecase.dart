import 'package:owl_fp/core/resources/data.state.dart';

import '../../repository/auth.repo.dart';

class ProfileUseCase {
  final AuthRepository repository;

  ProfileUseCase(this.repository);

  Future<DataState> execute() {
    return repository.getProfile();
  }
}
