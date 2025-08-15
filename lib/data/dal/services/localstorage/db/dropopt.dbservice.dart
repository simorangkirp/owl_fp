import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../presentation/constant.dart';
import '../../../../model/drop.opt.model.dart';

class DropOptDBHelper {
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

  // Upload And Download Template
  Future<void> insertTempAll(Map<String, dynamic> args) async {
    final db = await database;
    db.transaction((txn) async {
      txn.insert(DBConstant.tblFPKaryawan, args);
    });
  }

  Future<int> deleteTemplate(String arg) async {
    final db = await database;
    return await db.delete(
      DBConstant.tblFPKaryawan, // nama tabel
      where: 'sn = ?', // kondisi hapus
      whereArgs: [arg], // parameter kondisi
    );
    // return await db.delete(DBConstant.tblUser);
  }

  ///

  /// Dropdown Options
  Future<List<String>> getListStringOptQuery(String arg) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      DBConstant.tblDDList,
      where: 'submenu LIKE ?',
      whereArgs: ['%$arg%'],
    );
    return results.map((e) => e['value'] as String).toList();
  }

  Future<List<DropOptionModel>> getListModelOptQuery(String arg) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      DBConstant.tblDDList,
      where: 'submenu LIKE ?',
      whereArgs: ['%$arg%'],
    );
    var ret = <DropOptionModel>[];
    for (var element in results) {
      ret.add(DropOptionModel.fromJson(element));
    }
    return ret;
  }

  ///
}
