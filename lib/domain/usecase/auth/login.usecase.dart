import 'package:owl_fp/core/resources/data.state.dart';

import '../../repository/auth.repo.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<DataState> execute(String email, String password) {
    return repository.login(email, password);
  }
}
