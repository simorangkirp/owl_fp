import 'package:owl_fp/domain/repository/fp.repo.dart';

import '../../../data/model/mst.admin.model.dart';

class GetMasterAdminUsecase {
  final FingerprintRepository repository;

  GetMasterAdminUsecase(this.repository);

  Future<List<MstAdminModel>> execute() {
    return repository.getMstAdmin();
  }
}
