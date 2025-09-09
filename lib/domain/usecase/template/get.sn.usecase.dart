import 'package:owl_fp/domain/repository/template.repository.dart';

class GetSNListUsecase {
  final TemplateRepository repository;

  GetSNListUsecase(this.repository);

  Future<List<String>> execute() {
    return repository.getSnList();
  }
}
