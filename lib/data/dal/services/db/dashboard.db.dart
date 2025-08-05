import '../db.helper.dart';

abstract class DashboardLocalDataSource {
  Future<List<String>> masterdatalist();
}

class DashboardLocalDataSourceImpl extends DashboardLocalDataSource {
  final DatabaseHelper databaseHelper;
  DashboardLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<String>> masterdatalist() async {
    var response = await databaseHelper.getMasterHeader();
    return response;
  }
}
