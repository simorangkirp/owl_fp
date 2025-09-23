import '../../repository/dashboard.repo.dart';

class GetMasterHeaderUseCase {
  final DashboardRepository repository;

  GetMasterHeaderUseCase(this.repository);

  Future<List<String>> execute() {
    return repository.getMasterList();
  }
}
