import 'package:owl_fp_newer/core/resources/data.state.dart';

import '../../repository/auth.repo.dart';

class ProfileUseCase {
  final AuthRepository repository;

  ProfileUseCase(this.repository);

  Future<DataState> execute() async {
    var result = await repository.getProfile();
    if (result is DataError) {
      final message = result.error?.toString() ?? "Terjadi kesalahan.";
      // 🚨 Langsung throw biar bisa di-catch di controller
      throw Exception(message);
    }
    return result;
  }
}
