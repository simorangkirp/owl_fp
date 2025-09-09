import 'package:owl_fp/domain/repository/template.repository.dart';

class GetKaryawanUseCase {
  final TemplateRepository repository;

  GetKaryawanUseCase(this.repository);

  Future<List<String>> execute(String args) {
    return repository.getKaryawanList(args);
  }
}
