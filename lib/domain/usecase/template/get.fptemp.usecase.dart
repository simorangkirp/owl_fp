import 'package:owl_fp_newer/domain/repository/template.repository.dart';

class KaryawanFPTemplateUsecase {
  final TemplateRepository repository;

  KaryawanFPTemplateUsecase(this.repository);

  Future<List<String>> execute(Map<String, dynamic> args) {
    return repository.getKaryawanFingerList(args);
  }
}
