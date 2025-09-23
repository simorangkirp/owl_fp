import '../../repository/fp.repo.dart';

class GetSNListUsecase {
  final FingerprintRepository repository;

  GetSNListUsecase(this.repository);

  Future<List<String>> execute() {
    return repository.getSnList();
  }
}
