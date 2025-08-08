import 'package:owl_fp/data/model/karyawan.model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? db;

  Future<Database> get database async {
    db ??= await initDB();
    return db!;
  }

  static const String _tblUser = 'user';
  static const String _tblMasterHeader = 'masterheader';
  static const String _tblDDList = 'ddlistmenu';
  static const String _tblKaryawan = 'karyawan';

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tblDDList (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            no INTEGER,
            key TEXT,
            value TEXT,
            menu TEXT,
            submenu TEXT            
          )
        ''');

        await db.execute('''
          CREATE TABLE $_tblMasterHeader (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE $_tblKaryawan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            karyawanid TEXT,
            nik TEXT,
            lokasitugas TEXT,
            subbagian TEXT,
            namakaryawan TEXT,
            tipekaryawan TEXT,
            namajabatan TEXT,
            kodejabatan TEXT,
            tanggalkeluar TEXT        
          )
        ''');

        await db.execute('''
          CREATE TABLE $_tblUser (
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

        var masterlist = [
          {'name': 'Karyawan'},
        ];

        //     no INTEGER,
        //         key TEXT,
        //         value TEXT,
        //         menu TEXT,
        //         submenu TEXT
        var dropdownlist = [
          {
            'no': 0,
            'key': 'wifi',
            'value': 'Wifi',
            'menu': 'fingerprint',
            'submenu': 'setting'
          },
          {
            'no': 1,
            'key': 'waktuupload',
            'value': 'Waktu Upload',
            'menu': 'fingerprint',
            'submenu': 'setting'
          },
          {
            'no': 2,
            'key': 'clientid',
            'value': 'Client ID',
            'menu': 'fingerprint',
            'submenu': 'setting'
          },
          {
            'no': 3,
            'key': 'alamatserver',
            'value': 'Alamat Server',
            'menu': 'fingerprint',
            'submenu': 'setting'
          },
          {
            'no': 4,
            'key': 'tanggaljam',
            'value': 'Tanggal & Jam',
            'menu': 'fingerprint',
            'submenu': 'setting'
          },
          {
            'no': 5,
            'key': 'waktudeleteabsen',
            'value': 'Waktu Delete Absen',
            'menu': 'fingerprint',
            'submenu': 'setting'
          },
          {
            'no': 1,
            'key': 'downloadtemplate',
            'value': 'Download Template dari Finger',
            'menu': 'fingerprint',
            'submenu': 'downloadupload'
          },
          {
            'no': 2,
            'key': 'downloadtemplatenik',
            'value': 'Download Template per NIK',
            'menu': 'fingerprint',
            'submenu': 'downloadupload'
          },
          {
            'no': 3,
            'key': 'uploadtemplatemobilefinger',
            'value': 'Upload Template dari Mobile ke Fingerprint',
            'menu': 'fingerprint',
            'submenu': 'downloadupload'
          },
          {
            'no': 1,
            'key': 'gantipin',
            'value': 'Ganti Pin',
            'menu': 'fingerprint',
            'submenu': 'admin'
          },
          {
            'no': 2,
            'key': 'tambahadmin',
            'value': 'Tambah Admin Fingerprint',
            'menu': 'fingerprint',
            'submenu': 'admin'
          },
          {
            'no': 3,
            'key': 'deletebynik',
            'value': 'Delete Fingerprint by NIK',
            'menu': 'fingerprint',
            'submenu': 'admin'
          },
        ];
        for (var element in masterlist) {
          db.insert(_tblMasterHeader, element);
        }
        for (var element in dropdownlist) {
          db.insert(_tblDDList, element);
        }
      },
    );
  }

  // Delete Karyawan All
  Future<int> deleteAllKaryawan() async {
    final db = await database;
    return await db.delete(_tblKaryawan);
  }

  // Sync Karyawan
  Future<void> syncKaryawan(List<dynamic> data) async {
    final db = await database;
    db.transaction((txn) async {
      for (final karyawan in data) {
        txn.insert(_tblKaryawan, karyawan.toTable());
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
      _tblKaryawan,
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

  //Insert User
  Future<void> insertUser(Map<String, dynamic> args) async {
    final db = await database;
    db.transaction((txn) async {
      txn.insert(_tblUser, args);
    });
  }

  // Delete User
  Future<int> deleteUser() async {
    final db = await database;
    return await db.delete(_tblUser);
  }

  // Get User
  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT * FROM $_tblUser');
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  // Get List Master Header
  Future<List<String>> getMasterHeader() async {
    final db = await database;
    var data = <String>[];
    final List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT * FROM $_tblMasterHeader');
    if (results.isNotEmpty) {
      for (var element in results) {
        data.add(element['name']);
      }
      return data;
    }
    return data;
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
