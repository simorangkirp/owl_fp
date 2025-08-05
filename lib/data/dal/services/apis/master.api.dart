import 'package:dio/dio.dart';
import 'package:owl_fp/data/model/karyawan.model.dart';

import '../../../dio/dio.client.dart';
import '../../../model/master.model.dart';
import '../get.storage.dart';

abstract class MasterRemoteDataSource {
  Future<List<KaryawanModel>?> remoteKaryawan();
}

class MasterRemoteDataSourceImpl extends MasterRemoteDataSource {
  final DioClient dioClient;

  MasterRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService();

  @override
  Future<List<KaryawanModel>?> remoteKaryawan() async {
    // var ret = <KaryawanModel>[];
    final box = StorageService();
    final Response response = await dioClient.post(
      '${box.bUrl}/module/setupmasterdata/getmasterdata/load',
      options: Options(
        headers: {'api_key': box.token},
      ),
    );
    if (response.data['error'] == false) {
      var parsed = MasterModel.fromJson(response.data['result']);
      return parsed.karyawan;
    }
    return null;
  }
}
