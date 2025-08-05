import 'package:owl_fp/domain/entity/profile.entity.dart';
import 'package:owl_fp/domain/repository/profile.repository.dart';

import '../../services/apis/profile.api.dart';
import '../../services/db/profile.db.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<ProfileEntity> getUser() async {
    final response = await localDataSource.user();
    return response.toEntity();
  }
}
