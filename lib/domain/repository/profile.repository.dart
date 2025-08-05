import '../entity/profile.entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getUser();
}
