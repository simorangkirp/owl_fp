import 'package:owl_fp/domain/repository/fp.repo.dart';

class GetUploadDownloadOptionsUseCase {
  final FingerprintRepository repository;

  GetUploadDownloadOptionsUseCase(this.repository);

  Future<List<String>> execute(String arg) {
    return repository.getUploadDownloadOpt(arg);
  }
}
