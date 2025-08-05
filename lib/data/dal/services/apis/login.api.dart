import 'package:dio/dio.dart';

import '../../../dio/dio.client.dart';
import '../../../model/profile.model.dart';
import '../get.storage.dart';

abstract class AuthRemoteDataSource {
  Future<bool> login(
    Map<String, dynamic> payload,
  );
  Future<ProfileModel> profile();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService();

  @override
  Future<bool> login(
    Map<String, dynamic> payload,
  ) async {
    final box = StorageService();
    final Response response = await dioClient.post(
      '${box.bUrl}/login',
      data: payload,
    );
    if (response.data['error'] == true) {
      return false;
    } else {
      box.saveToken(response.data['result']['api_key']);
      return true;
    }
  }

  @override
  Future<ProfileModel> profile() async {
    final box = StorageService();
    final Response response = await dioClient.post(
      '${box.bUrl}/profile',
      options: Options(
        headers: {'api_key': box.token},
      ),
    );
    return ProfileModel.fromJson(response.data['result']['empl']);
  }
}
