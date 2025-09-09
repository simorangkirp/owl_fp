import 'package:owl_fp/domain/repository/fp.repo.dart';

class SendTemplateUseCase {
  final FingerprintRepository repository;

  SendTemplateUseCase(this.repository);

  Future<void> execute(Map<String, dynamic> arg) {
    return repository.uploadTemplateServer(arg);
  }
}
