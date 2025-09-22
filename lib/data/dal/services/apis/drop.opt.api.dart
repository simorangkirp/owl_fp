import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class DropOptRemoteDataSource {
  Future<HttpResponse<dynamic>> sendTemplateServer(
    Map<String, dynamic> payload,
  );
}

class DropOptRemoteDataSourceImpl extends DropOptRemoteDataSource {
  final DioClient dioClient;

  DropOptRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<HttpResponse<dynamic>> sendTemplateServer(
      Map<String, dynamic> payload) async {
    final box = StorageService.instance;
    final Response response =
        await dioClient.post('${box.bUrl}/module/fingerprint/datatemplate/send',
            data: payload,
            options: Options(
              headers: {
                'api_key': '${box.token}', // atau sesuai format API mu
                'Content-Type': 'application/json',
              },
            ));
    final value = response.data;
    final httpResponse = HttpResponse(value, response);
    return httpResponse;
  }
}
