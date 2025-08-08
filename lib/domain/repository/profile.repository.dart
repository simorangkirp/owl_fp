import 'package:owl_fp/domain/entity/profile.entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getUser();
}
