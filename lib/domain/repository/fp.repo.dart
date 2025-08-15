import '../entity/dropopt.entity.dart';

abstract class FingerprintRepository {
  Future<List<DropOptionEntity>> getSettingOpt(String arg);
  Future<List<String>> getUploadDownloadOpt(String arg);
  Future<List<String>> getBtstatOpt(String arg);
  Future<List<String>> getDtOpt(String arg);
  Future<void> insertTemplate(List<Map<String, dynamic>> args);
  Future<int> deleteTempAfterInsert(String args);
}
