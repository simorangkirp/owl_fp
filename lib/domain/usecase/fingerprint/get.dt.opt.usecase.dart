import 'package:owl_fp_newer/domain/repository/fp.repo.dart';

class GetDTOptUseCase {
  final FingerprintRepository repository;

  GetDTOptUseCase(this.repository);

  Future<List<String>> execute(String arg) {
    return repository.getDtOpt(arg);
  }
}
