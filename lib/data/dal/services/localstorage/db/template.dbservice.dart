import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../presentation/constant.dart';

class TemplateDBHelper {
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

  Future<List<String>> querySN() async {
    final db = await database;
    log("Masuk Sini GAYSS");
    final List<Map<String, dynamic>> results = await db.query(
      DBConstant.tblFPKaryawan,
    );
    var mp = results.map((e) => e['sn'] as String).toSet().toList();
    for (var element in mp) {
      log(element);
     }
    return results.map((e) => e['sn'] as String).toSet().toList();
  }

  Future<List<String>> queryTemplFP(Map<String, dynamic> query) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      DBConstant.tblFPKaryawan,
      where: '''
      sn LIKE ? AND
      nama LIKE ?
      ''',
      whereArgs: [
        '%${query['sn']}%',
        '%${query['nama']}%',
      ],
    );
    return results.map((e) => e['template'] as String).toList();
  }

  Future<List<String>> queryKaryawan(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      DBConstant.tblFPKaryawan,
      where: '''
      sn LIKE ?
      ''',
      whereArgs: [
        '%$query%',
      ],
    );
    return results.map((e) => e['nama'] as String).toSet().toList();
  }
}
