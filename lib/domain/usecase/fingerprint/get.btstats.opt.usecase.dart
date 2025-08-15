import 'package:owl_fp/domain/repository/fp.repo.dart';

class GetBtstatsOptUseCase {
  final FingerprintRepository repository;

  GetBtstatsOptUseCase(this.repository);

  Future<List<String>> execute(String arg) {
    return repository.getBtstatOpt(arg);
  }
}
