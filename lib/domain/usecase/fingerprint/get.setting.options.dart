import 'package:owl_fp/domain/entity/dropopt.entity.dart';

import '../../repository/fp.repo.dart';

class GetSettingOptionsUseCase {
  final FingerprintRepository repository;

  GetSettingOptionsUseCase(this.repository);

  Future<List<DropOptionEntity>> execute(String arg) {
    return repository.getSettingOpt(arg);
  }
}
