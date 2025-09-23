import '../../repository/master.repo.dart';

class GetLogMasterUsecase {
  final MasterDataRepository repository;

  GetLogMasterUsecase(this.repository);

  Future<String?> execute(String args) {
    return repository.getLogMaster(args);
  }
}
