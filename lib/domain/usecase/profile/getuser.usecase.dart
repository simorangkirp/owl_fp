import 'package:owl_fp_newer/domain/entity/profile.entity.dart';

import '../../repository/profile.repository.dart';

class GetUserUseCase {
  final ProfileRepository repository;

  GetUserUseCase(this.repository);

  Future<ProfileEntity> execute() {
    return repository.getUser();
  }
}
