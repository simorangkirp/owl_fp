import '../db.helper.dart';

abstract class AuthLocalDataSource {
  Future<void> insertUser(Map<String, dynamic> args);
  Future<void> deleteUser();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final DatabaseHelper databaseHelper;
  AuthLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> insertUser(Map<String, dynamic> args) async {
    await databaseHelper.insertUser(args);
  }

  @override
  Future<void> deleteUser() async {
    await databaseHelper.deleteUser();
  }
}
