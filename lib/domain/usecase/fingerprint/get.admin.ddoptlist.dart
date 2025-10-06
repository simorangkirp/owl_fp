import 'package:owl_fp_newer/domain/repository/fp.repo.dart';

class GetAdminOptionsUseCase {
  final FingerprintRepository repository;

  GetAdminOptionsUseCase(this.repository);

  Future<List<String>> execute(String arg) {
    return repository.getAdminOpt(arg);
  }
}
