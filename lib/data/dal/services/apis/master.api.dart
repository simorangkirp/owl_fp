import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class MasterRemoteDataSource {
  Future<HttpResponse<dynamic>> remoteKaryawan();
}

class MasterRemoteDataSourceImpl extends MasterRemoteDataSource {
  final DioClient dioClient;

  MasterRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService.instance;

  @override
  Future<HttpResponse<dynamic>> remoteKaryawan() async {
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
