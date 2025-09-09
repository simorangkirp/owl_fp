import 'package:dio/dio.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class DropOptRemoteDataSource {
  Future<bool> sendTemplateServer(
    Map<String, dynamic> payload,
  );
}

class DropOptRemoteDataSourceImpl extends DropOptRemoteDataSource {
  final DioClient dioClient;

  DropOptRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService();

  @override
  Future<bool> sendTemplateServer(Map<String, dynamic> payload) async {
    final box = StorageService();
    final Response response =
        await dioClient.post('${box.bUrl}/module/fingerprint/datatemplate/send',
            data: payload,
            options: Options(
              headers: {
                'api_key': '${box.token}', // atau sesuai format API mu
                'Content-Type': 'application/json',
              },
            ));
    if (response.data['error'] == true) {
      return false;
    } else {
      // box.saveToken(response.data['result']['api_key']);
      return true;
    }
  }
}
