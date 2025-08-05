import 'package:owl_fp/domain/entity/profile.entity.dart';

import '../../../../domain/repository/auth.repo.dart';
import '../../services/apis/login.api.dart';
import '../../services/db/auth.db.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<bool> login(String user, String password) async {
    Map<String, dynamic> payload = {
      'username': user,
      'password': password,
      'uuid': 'cobauuid',
    };
    final response = await remoteDataSource.login(payload);
    return response;
  }

  @override
  Future<ProfileEntity> profile() async {
    final response = await remoteDataSource.profile();
    localDataSource.insertUser(response);
    return response.toEntity();
  }
}
