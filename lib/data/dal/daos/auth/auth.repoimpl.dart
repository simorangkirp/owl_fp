import 'package:owl_fp/domain/entity/auth.entity.dart';

import '../../../../domain/repository/auth.repo.dart';
import '../../../model/auth.model.dart';
import '../../services/apis/login.api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> login(String user, String password) async {
    Map<String, dynamic> payload = {
      'username': user,
      'password': password,
      'uuid': 'cobauuid',
      // 'appname': 'com.owl.palma',
    };
    final response = await remoteDataSource.login(payload);
    return response;
  }
}
