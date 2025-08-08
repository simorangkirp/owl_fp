import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class ProfileRemoteDataSource {
  Future<HttpResponse<dynamic>> profile();
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService();

  @override
  Future<HttpResponse<dynamic>> profile() async {
    final response = await dioClient.post(
      '${box.bUrl}/profile',
      options: Options(
        headers: {'api_key': box.token},
      ),
    );
    final httpResponse = HttpResponse(response, response);
    return httpResponse;
  }
}
