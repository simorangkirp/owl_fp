import 'package:owl_fp/data/model/template.model.dart';
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
  Future<int> deleteTemp(String args) async {
    return await localDataSource.deleteTempLocal(args);
  }

  @override
  Future<List<String>> getSnList() async {
    return await localDataSource.getSn();
  }

  @override
  Future<void> uploadTemplateServer(Map<String, dynamic> args) async {
    final response = await remoteDataSource.sendTemplateServer(args);
    // return response;
  }

  @override
  Future<List<TemplateModel>> getTemplateData(String args) async {
    return await localDataSource.getTemplateData(args);
  }
}
