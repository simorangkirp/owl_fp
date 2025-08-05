import '../../../model/profile.model.dart';
import '../db.helper.dart';

abstract class AuthLocalDataSource {
  Future<bool> insertUser(ProfileModel user);
  Future<void> deleteUser();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final DatabaseHelper databaseHelper;
  AuthLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<bool> insertUser(ProfileModel user) async {
    try {
      Map<String, dynamic> args = user.toJson();
      await databaseHelper.insertUser(args);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteUser() async {
    await databaseHelper.deleteUser();
  }
}
