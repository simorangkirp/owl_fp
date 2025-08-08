import 'dart:developer';
import 'dart:io';
import 'package:owl_fp/core/resources/data.state.dart';
import '../../../../domain/repository/auth.repo.dart';
import '../../../dio/dio.exception.dart';
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
  Future<DataState> getProfile() async {
    try {
      final httpResp = await remoteDataSource.profile();
      switch (httpResp.response.statusCode) {
        case HttpStatus.ok:
          Map<String, dynamic> args = httpResp.data["result"]["empl"];
          await localDataSource.deleteUser();
          await localDataSource.insertUser(args);
          return DataSuccess(httpResp.data);
        case HttpStatus.requestTimeout:
          return DataError(httpResp.data);
        default:
      }
      return DataError(httpResp.data);
    } on DioException catch (e) {
      return DataError(e);
    }
  }
}
