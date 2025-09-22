import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class AuthRemoteDataSource {
  Future<HttpResponse<dynamic>> login(
    Map<String, dynamic> payload,
  );
  Future<HttpResponse<dynamic>> profile();
  Future<HttpResponse<dynamic>> getMasterData();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService.instance;

  @override
  Future<HttpResponse<dynamic>> login(
    Map<String, dynamic> payload,
  ) async {
    final Response response = await dioClient.post(
      '${box.bUrl}/login',
      data: payload,
    );
    final value = response.data;
    final httpResponse = HttpResponse(value, response);
    return httpResponse;
    // if (response.data['error'] == true) {
    //   return false;
    // } else {
    //   return true;
    // }
  }

  @override
  Future<HttpResponse<dynamic>> profile() async {
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

  @override
  Future<HttpResponse> getMasterData() async {
    // var ret = <KaryawanModel>[];
    final Response response = await dioClient.post(
      '${box.bUrl}/module/setupmasterdata/getmasterdata/load',
      options: Options(
        headers: {'api_key': box.token},
      ),
    );
    final value = response.data;
    final httpResponse = HttpResponse(value, response);
    return httpResponse;
  }
}
