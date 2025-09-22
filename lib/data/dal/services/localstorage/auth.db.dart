import '../../../model/karyawan.model.dart';
import 'db/user.dbservice.dart';

abstract class AuthLocalDataSource {
  Future<void> insertUser(Map<String, dynamic> args);
  Future<void> deleteUser();
  Future<void> insertLogSnyc(Map<String, dynamic> args);
  Future<void> syncKaryawan(List<KaryawanModel> list);
  Future<void> deleteKaryawan();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final UserDBHelper databaseHelper;
  AuthLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> insertUser(Map<String, dynamic> args) async {
    await databaseHelper.insertUser(args);
  }

  @override
  Future<void> deleteUser() async {
    await databaseHelper.deleteUser();
  }

  @override
  Future<void> deleteKaryawan() async {
    await databaseHelper.deleteAllKaryawan();
  }

  @override
  Future<void> syncKaryawan(List<KaryawanModel> list) async {
    await databaseHelper.syncKaryawan(list);
  }

  @override
  Future<void> insertLogSnyc(Map<String, dynamic> args) async {
    await databaseHelper.addLog(args);
  }
}
