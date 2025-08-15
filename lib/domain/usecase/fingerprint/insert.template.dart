import 'package:owl_fp/domain/repository/fp.repo.dart';

class InsertTemplateUseCase {
  final FingerprintRepository repository;

  InsertTemplateUseCase(this.repository);

  Future<void> execute(List<Map<String, dynamic>> arg) {
    return repository.insertTemplate(arg);
  }
}
