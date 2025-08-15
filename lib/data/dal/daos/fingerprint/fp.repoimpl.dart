import 'package:owl_fp/domain/entity/dropopt.entity.dart';

import '../../../../domain/repository/fp.repo.dart';
import '../../services/apis/drop.opt.api.dart';
import '../../services/localstorage/drop.opt.db.dart';

class FingerprintRepoImpl implements FingerprintRepository {
  final DropOptLocalDataSource localDataSource;
  final DropOptRemoteDataSource remoteDataSource;

  FingerprintRepoImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<DropOptionEntity>> getSettingOpt(arg) async {
    var ret = <DropOptionEntity>[];
    final response = await localDataSource.getSettingOpt(arg);
    for (var el in response) {
      ret.add(el.toEntity());
    }
    return ret;
  }

  @override
  Future<List<String>> getUploadDownloadOpt(arg) async {
    return await localDataSource.getUploadDownloadOpt(arg);
  }

  @override
  Future<List<String>> getBtstatOpt(arg) async {
    return await localDataSource.getBtstsOpt(arg);
  }

  @override
  Future<List<String>> getDtOpt(arg) async {
    return await localDataSource.getDtimeOpt(arg);
  }

  @override
  Future<void> insertTemplate(List<Map<String, dynamic>> args) async {
    return await localDataSource.insertTemplateAll(args);
  }

  @override
  Future<int> deleteTempAfterInsert(String args) async {
    return await localDataSource.deleteTempAfterInsert(args);
  }
}
