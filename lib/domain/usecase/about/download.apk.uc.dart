import 'package:owl_fp_newer/core/resources/data.state.dart';
import 'package:owl_fp_newer/domain/repository/about.repo.dart';

class DownloadLatestVerUseCase {
  final AboutRepository repository;

  DownloadLatestVerUseCase(this.repository);

  Future<DataState> execute() {
    return repository.downloadLatestVersion();
  }
}
