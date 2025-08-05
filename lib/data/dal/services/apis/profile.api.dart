import '../../../dio/dio.client.dart';
import '../../../model/profile.model.dart';
import '../get.storage.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> profile();
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService();

  @override
  Future<ProfileModel> profile() {
    // TODO: implement profile
    throw UnimplementedError();
  }
}
