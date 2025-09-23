import '../../../data/model/icon.menu.model.dart';
import '../../repository/dashboard.repo.dart';

class GetIconMenuDashboardUsecase {
  final DashboardRepository repository;

  GetIconMenuDashboardUsecase(this.repository);

  Future<List<DashboardIconMenuModel>?> execute() {
    return repository.getIconMenuDashboardList();
  }
}
