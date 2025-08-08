import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class DropOptRemoteDataSource {}

class DropOptRemoteDataSourceImpl extends DropOptRemoteDataSource {
  final DioClient dioClient;

  DropOptRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService();
}
