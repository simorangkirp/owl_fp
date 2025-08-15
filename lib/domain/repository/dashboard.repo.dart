import '../../data/model/icon.menu.model.dart';

abstract class DashboardRepository {
  Future<List<String>> getMasterList();
  Future<List<DashboardIconMenuModel>?> getIconMenuDashboardList();
}
