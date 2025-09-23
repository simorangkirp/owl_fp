import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../presentation/constant.dart';

class UserDBHelper {
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

  //Insert User
  Future<void> insertUser(Map<String, dynamic> args) async {
    final db = await database;
    db.transaction((txn) async {
      txn.insert(DBConstant.tblUser, args);
    });
  }

// Delete User
  Future<int> deleteUser() async {
    final db = await database;
    return await db.delete(DBConstant.tblUser);
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

  Future<void> addLog(Map<String, dynamic> args) async {
    log("Add Log Last Sync\n");
    log(args["name"]);
    log(args["lastUpdate"].toString());
    final db = await database;
    db.transaction((txn) async {
      txn.insert(DBConstant.tblLogMstSync, args);
    });
  }

// Get User
  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT * FROM ${DBConstant.tblUser}');
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }
}
