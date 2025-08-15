import 'package:owl_fp/domain/repository/fp.repo.dart';

class DeleteTemplateUseCase {
  final FingerprintRepository repository;

  DeleteTemplateUseCase(this.repository);

  Future<int> execute(String arg) {
    return repository.deleteTempAfterInsert(arg);
  }
}
