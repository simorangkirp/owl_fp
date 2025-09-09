import 'package:owl_fp/data/model/template.model.dart';

import '../../../model/drop.opt.model.dart';
import 'db/dropopt.dbservice.dart';

abstract class DropOptLocalDataSource {
  Future<List<DropOptionModel>> getSettingOpt(String arg);
  Future<List<String>> getUploadDownloadOpt(String arg);
  Future<List<String>> getBtstsOpt(String arg);
  Future<List<String>> getDtimeOpt(String arg);
  Future<void> insertTemplateAll(List<Map<String, dynamic>> arg);
  Future<int> deleteTempLocal(String arg);
  Future<List<String>> getSn();
  Future<List<TemplateModel>> getTemplateData(String arg);
}

class DropOptLocalDataSourceImpl extends DropOptLocalDataSource {
  final DropOptDBHelper databaseHelper;
  DropOptLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<DropOptionModel>> getSettingOpt(arg) async {
    return await databaseHelper.getListModelOptQuery(arg);
  }

  @override
  Future<List<String>> getUploadDownloadOpt(arg) async {
    return await databaseHelper.getListStringOptQuery(arg);
  }

  @override
  Future<List<String>> getBtstsOpt(arg) async {
    return await databaseHelper.getListStringOptQuery(arg);
  }

  @override
  Future<List<String>> getDtimeOpt(arg) async {
    return await databaseHelper.getListStringOptQuery(arg);
  }

  @override
  Future<void> insertTemplateAll(List<Map<String, dynamic>> arg) async {
    for (var element in arg) {
      await databaseHelper.insertTempAll(element);
    }
  }

  @override
  Future<int> deleteTempLocal(String arg) async {
    return await databaseHelper.deleteTemplate(arg);
  }

  @override
  Future<List<String>> getSn() async {
    return await databaseHelper.querySN();
  }

  @override
  Future<List<TemplateModel>> getTemplateData(String arg) async {
    return await databaseHelper.queryTemplFP(arg);
  }
}
