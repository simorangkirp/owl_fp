import '../../../../domain/repository/dashboard.repo.dart';
import '../../services/db/dashboard.db.dart';

class DashboardRepoImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  DashboardRepoImpl(this.localDataSource);

  @override
  Future<List<String>> getMasterList() async {
    final response = await localDataSource.masterdatalist();
    return response;
  }
}
