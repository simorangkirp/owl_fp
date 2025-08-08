import '../../../model/drop.opt.model.dart';
import '../db.helper.dart';

abstract class DropOptLocalDataSource {
  Future<DropOptionModel> getSettingOpt();
  Future<DropOptionModel> getUploadDownloadOpt();
}

class DropOptLocalDataSourceImpl extends DropOptLocalDataSource {
  final DatabaseHelper databaseHelper;
  DropOptLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<DropOptionModel> getSettingOpt() {
    // TODO: implement getSettingOpt
    throw UnimplementedError();
  }

  @override
  Future<DropOptionModel> getUploadDownloadOpt() {
    // TODO: implement getUploadDownloadOpt
    throw UnimplementedError();
  }
}
