import 'dart:io';

import 'package:owl_fp/domain/entity/karyawan.entity.dart';
import 'package:owl_fp/domain/repository/master.repo.dart';

import '../../../../core/resources/data.state.dart';
import '../../../dio/dio.exception.dart';
import '../../../model/master.model.dart';
import '../../services/apis/master.api.dart';
import '../../services/localstorage/master.db.dart';

class MasterRepositoryImpl implements MasterDataRepository {
  final MasterLocalDataSource localDataSource;
  final MasterRemoteDataSource remoteDataSource;

  MasterRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<DataState> getKaryawan() async {
    var ret = <KaryawanEntity>[];
    // final response = await remoteDataSource.remoteKaryawan();
    // if (response != null) {
    //   for (var el in response) {
    //     ret.add(el.toEntity());
    //   }
    //   await localDataSource.deleteKaryawan();
    //   await localDataSource.syncKaryawan(response);
    // }
    // return ret;

    //  var parsed = MasterModel.fromJson(response.data['result']);

    try {
      final httpResp = await remoteDataSource.remoteKaryawan();
      switch (httpResp.response.statusCode) {
        case HttpStatus.ok:
          var parsed = MasterModel.fromJson(httpResp.response.data['result']);
          for (var element in parsed.karyawan) {
            ret.add(element.toEntity());
          }
          await localDataSource.deleteKaryawan();
          await localDataSource.syncKaryawan(parsed.karyawan);
          return DataSuccess(ret);
        case HttpStatus.requestTimeout:
          return DataError(httpResp.data);
        default:
      }
      return DataError(httpResp.data);
    } on DioException catch (e) {
      return DataError(e);
    }
  }

  @override
  Future<List<KaryawanEntity>?> getKaryawanTuple(String args) async {
    var ret = <KaryawanEntity>[];
    final response = await localDataSource.searchKaryawanArgs(args);
    if (response != null) {
      for (var el in response) {
        ret.add(el.toEntity());
      }
    }
    return ret;
  }
}
