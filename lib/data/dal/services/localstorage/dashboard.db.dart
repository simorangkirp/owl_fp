import 'package:owl_fp/data/model/icon.menu.model.dart';

import 'db/dashboard.dbservice.dart';

abstract class DashboardLocalDataSource {
  Future<List<String>> masterdatalist();
  Future<List<DashboardIconMenuModel>?> iconMenuList();
}

class DashboardLocalDataSourceImpl extends DashboardLocalDataSource {
  final DashboardDBHelper databaseHelper;
  DashboardLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<String>> masterdatalist() async {
    var response = await databaseHelper.getMasterHeader();
    return response;
  }

  @override
  Future<List<DashboardIconMenuModel>?> iconMenuList() async {
    var response = await databaseHelper.getIconMenuDashboard();
    if (response != null && response.isNotEmpty) {
      var result =
          response.map((e) => DashboardIconMenuModel.fromMap(e)).toList();
      return result;
    } else {
      return null;
    }
  }
}
