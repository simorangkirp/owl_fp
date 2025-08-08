import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class AuthRemoteDataSource {
  Future<bool> login(
    Map<String, dynamic> payload,
  );
  Future<HttpResponse<dynamic>> profile();
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
  Future<HttpResponse<dynamic>> profile() async {
    final box = StorageService();
    final response = await dioClient.post(
      '${box.bUrl}/profile',
      options: Options(
        headers: {'api_key': box.token},
      ),
    );
    final value = response.data;
    final httpResponse = HttpResponse(value, response);
    return httpResponse;
  }
}
