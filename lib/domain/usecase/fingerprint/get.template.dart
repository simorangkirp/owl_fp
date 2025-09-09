import 'package:owl_fp/data/model/template.model.dart';
import '../../repository/fp.repo.dart';

class GetDataTemplate {
  final FingerprintRepository repository;

  GetDataTemplate(this.repository);

  Future<List<TemplateModel>> execute(args) {
    return repository.getTemplateData(args);
  }
}
