import '../../entity/profile.entity.dart';
import '../../repository/auth.repo.dart';

class ProfileUseCase {
  final AuthRepository repository;

  ProfileUseCase(this.repository);

  Future<ProfileEntity> execute() {
    return repository.profile();
  }
}
