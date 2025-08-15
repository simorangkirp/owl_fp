import 'package:owl_fp/data/model/icon.menu.model.dart';

import '../../../../domain/repository/dashboard.repo.dart';
import '../../services/localstorage/dashboard.db.dart';

class DashboardRepoImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  DashboardRepoImpl(this.localDataSource);

  @override
  Future<List<String>> getMasterList() async {
    final response = await localDataSource.masterdatalist();
    return response;
  } 

  @override
  Future<List<DashboardIconMenuModel>?> getIconMenuDashboardList() async {
    return await localDataSource.iconMenuList();
  }
}
