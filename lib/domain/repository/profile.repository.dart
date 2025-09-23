import 'package:owl_fp_newer/domain/entity/profile.entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getUser();
}
