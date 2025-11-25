import 'package:owl_fp_newer/core/resources/data.state.dart';
import 'package:owl_fp_newer/domain/repository/about.repo.dart';

class GetAppVersionUseCase {
  final AboutRepository repository;

  GetAppVersionUseCase(this.repository);

  Future<DataState> execute() {
    return repository.getVersion();
  }
}
