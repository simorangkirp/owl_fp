import 'package:owl_fp_newer/core/resources/data.state.dart';

import '../../repository/auth.repo.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<DataState> execute(String email, String password) async {
    var result = await repository.login(email, password);

    if (result is DataError) {
      // 🚨 Langsung throw biar bisa di-catch di controller
      final message = result.error?.toString() ?? "Terjadi kesalahan.";
      throw Exception(message);
    }
    return result;
  }
}
