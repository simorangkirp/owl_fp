import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../presentation/constant.dart';
import '../../../../model/karyawan.model.dart';

class KaryawanDBHelper {
  Database? db;
  Future<Database> get database async {
    db ??= await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');
    return await openDatabase(path);
  }

  // Delete Karyawan All
  Future<int> deleteAllKaryawan() async {
    final db = await database;
    return await db.delete(DBConstant.tblKaryawan);
  }

  // Sync Karyawan
  Future<void> syncKaryawan(List<dynamic> data) async {
    final db = await database;
    db.transaction((txn) async {
      for (final karyawan in data) {
        txn.insert(DBConstant.tblKaryawan, karyawan.toTable());
      }
    });
  }

  Future<List<String>> searchKaryawan(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'karyawan',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return results.map((e) => e['name'] as String).toList();
  }

  Future<List<KaryawanModel>?> searchKaryawanTuple(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      DBConstant.tblKaryawan,
      where: '''
    namakaryawan LIKE ? OR 
    nik LIKE ? OR 
    lokasitugas LIKE ?
  ''',
      whereArgs: [
        '%$query%',
        '%$query%',
        '%$query%',
      ],
    );
    var res = <KaryawanModel>[];
    for (var element in results) {
      res.add(KaryawanModel.fromJson(element));
    }
    return res;
  }
}
