import 'package:owl_fp_newer/domain/repository/fp.repo.dart';

class DeleteTemplateUseCase {
  final FingerprintRepository repository;

  DeleteTemplateUseCase(this.repository);

  Future<int> execute(String arg) {
    return repository.deleteTemp(arg);
  }
}

class DeleteTemplateByNikUseCase {
  final FingerprintRepository repository;

  DeleteTemplateByNikUseCase(this.repository);

  Future<int> execute(Map<String, String> arg) {
    return repository.deleteTempbyNik(arg);
  }
}
