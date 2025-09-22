import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:owl_fp/core/resources/data.state.dart';
import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/repository/auth.repo.dart';
import '../../../../presentation/constant.dart';
import '../../../model/log.mst.sync.model.dart';
import '../../../model/master.model.dart';
import '../../services/apis/login.api.dart';
import '../../services/get.storage.dart';
import '../../services/localstorage/auth.db.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<DataState> login(String user, String password) async {
    final payload = {
      'username': user,
      'password': password,
      'uuid': 'cobauuid',
    };

    try {
      final httpResp = await remoteDataSource.login(payload);
      final statusCode = httpResp.response.statusCode ?? 500;
      final data = httpResp.data;

      switch (statusCode) {
        case HttpStatus.ok:
          final result = data['result'];
          final box = StorageService.instance;

          box.saveToken(result['api_key']);
          box.saveKebun(result['kodeorg']);
          box.saveExpKey(result['explogin']);

          log("Login success. Token expiry: ${result['explogin']}");

          return DataSuccess(data);

        case HttpStatus.requestTimeout:
          return const DataError("Request timeout");

        default:
          log("Unhandled status code: $statusCode");
          return DataError(data);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return const DataError("Connection Timeout");
      }
      return DataError(e); // langsung lempar DioError
    } catch (e) {
      return DataError(e.toString());
    }
  }

  @override
  Future<DataState> getProfile() async {
    try {
      final httpResp = await remoteDataSource.profile();
      final statusCode = httpResp.response.statusCode ?? 500;
      final data = httpResp.data;

      switch (statusCode) {
        case HttpStatus.ok:
          Map<String, dynamic> args = data["result"]["empl"];

          await localDataSource.deleteUser();
          await localDataSource.insertUser(args);

          // Logging
          var dataLog = LogMstSyncModel(
            name: LogConstant.mstKaryawan,
            lastUpdate: DateTime.now(),
          );
          log(dataLog.lastUpdate!.millisecondsSinceEpoch.toString());
          await localDataSource.insertLogSnyc(dataLog.toMap());

          return DataSuccess(data);

        case HttpStatus.requestTimeout:
          return const DataError("Request timeout");

        default:
          return DataError("Unhandled status code: $statusCode");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return const DataError("Connection Timeout");
      }
      return DataError(e);
    } catch (e) {
      return DataError(e.toString());
    }
  }

  @override
  Future<DataState> onLoginMasterDataRepo() async {
    var ret = <KaryawanEntity>[];
    try {
      final httpResp = await remoteDataSource.getMasterData();
      final statusCode = httpResp.response.statusCode ?? 500;
      final data = httpResp.data;

      if (statusCode == HttpStatus.ok) {
        var parsed = MasterModel.fromJson(data['result']);
        for (var element in parsed.karyawan) {
          ret.add(element.toEntity());
        }

        await localDataSource.deleteKaryawan();
        await localDataSource.syncKaryawan(parsed.karyawan);

        return DataSuccess(data);
      } else if (statusCode == HttpStatus.requestTimeout) {
        return const DataError("Request timeout");
      } else {
        return DataError("Unhandled status code: $statusCode");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return const DataError("Connection Timeout");
      }
      return DataError(e);
    } catch (e) {
      return DataError(e.toString());
    }
  }
}
