import '../entity/profile.entity.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<ProfileEntity> profile();
}
