import 'package:dio/dio.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class AuthRemoteDataSource {
  Future<bool> login(
    Map<String, dynamic> payload,
  );
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

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
      return true;
    }
  }
}
