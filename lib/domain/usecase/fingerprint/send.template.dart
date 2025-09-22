import 'package:owl_fp/domain/repository/fp.repo.dart';

import '../../../core/resources/data.state.dart';

class SendTemplateUseCase {
  final FingerprintRepository repository;

  SendTemplateUseCase(this.repository);

  Future<DataState> execute(Map<String, dynamic> arg) {
    return repository.uploadTemplateServer(arg);
  }
}
