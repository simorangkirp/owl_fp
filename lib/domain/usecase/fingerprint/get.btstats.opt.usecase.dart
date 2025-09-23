import 'package:owl_fp_newer/domain/repository/fp.repo.dart';

class GetBtstatsOptUseCase {
  final FingerprintRepository repository;

  GetBtstatsOptUseCase(this.repository);

  Future<List<String>> execute(String arg) {
    return repository.getBtstatOpt(arg);
  }
}
