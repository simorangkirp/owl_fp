import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../presentation/constant.dart';

class DashboardDBHelper {
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

  // Icon Menu Dashboard
  Future<List<Map<String, dynamic>>?> getIconMenuDashboard() async {
    final db = await database;
    return await db.query(DBConstant.tblDashMenuIcon);
  }

// Get List Master Header
  Future<List<String>> getMasterHeader() async {
    final db = await database;
    var data = <String>[];
    final List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT * FROM ${DBConstant.tblMasterHeader}');
    if (results.isNotEmpty) {
      for (var element in results) {
        data.add(element['name']);
      }
      return data;
    }
    return data;
  }
}
