import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE profile (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              sex TEXT,
              birthday TEXT,
              birthplace TEXT,
              address TEXT,
              noktp TEXT,
              nopaspor TEXT,
              nationality TEXT,
              religion TEXT,
              statusperkawinan TEXT,
              kodejabatan TEXT,
              jabatan TEXT,
              bagian TEXT,
              tipekaryawan TEXT,
              kodeorganisasi TEXT,
              namaorganisasi TEXT,
              lokasitugas TEXT,
              tipelokasitugas TEXT,
              subbagian TEXT,
              kodeorganisasi_temp TEXT,
              namaorganisasi_temp TEXT,
              lokasitugas_temp TEXT,
              tipelokasitugas_temp TEXT,
              subbagian_temp TEXT,
              poh TEXT,
              signdate TEXT,
              resigndate TEXT,
              sistemgaji TEXT,
              email TEXT,
              phone TEXT,
              regional TEXT
          );
        ''');
      },
    );
  }

  // Future<int> insertUser(User user) async {
  //   final db = await database;
  //   return await db.insert('users', user.toMap());
  // }

  // Future<List<User>> getUsers() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> result = await db.query('users');
  //   return result.map((e) => User.fromMap(e)).toList();
  // }

  // Future<int> updateUser(User user) async {
  //   final db = await database;
  //   return await db
  //       .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  // }

  // Future<int> deleteUser(int id) async {
  //   final db = await database;
  //   return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  // }
}
