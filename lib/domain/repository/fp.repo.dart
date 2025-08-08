import '../entity/dropopt.entity.dart';

abstract class FingerprintRepository {
  Future<DropOptionEntity> getSettingOpt();
  Future<DropOptionEntity> getUploadDownloadOpt();
}
