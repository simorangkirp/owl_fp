import 'package:owl_fp/domain/entity/dropopt.entity.dart';

import '../../../../domain/repository/fp.repo.dart';
import '../../services/apis/drop.opt.api.dart';
import '../../services/db/drop.opt.db.dart';

class FingerprintRepoImpl implements FingerprintRepository {
  final DropOptLocalDataSource localDataSource;
  final DropOptRemoteDataSource remoteDataSource;

  FingerprintRepoImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<DropOptionEntity> getSettingOpt() {
    // TODO: implement getSettingOpt
    throw UnimplementedError();
  }

  @override
  Future<DropOptionEntity> getUploadDownloadOpt() {
    // TODO: implement getUploadDownloadOpt
    throw UnimplementedError();
  }
}
