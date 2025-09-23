// import 'package:lucide_icons/lucide_icons.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../presentation/constant.dart';
import '../../model/icon.menu.model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? db;

  Future<Database> get database async {
    db ??= await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${DBConstant.tblDDList}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            no INTEGER,
            key TEXT,
            value TEXT,
            menu TEXT,
            submenu TEXT            
          )
        ''');

        await db.execute('''
          CREATE TABLE ${DBConstant.tblDashMenuIcon} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          menuNm TEXT NOT NULL,
          path TEXT NOT NULL,
          iconIndex INTEGER,
          iconCodePoint INTEGER,
          iconFontFamily TEXT,
          iconFontPackage TEXT,
          iconMatchTextDirection INTEGER          
          )
        ''');

        await db.execute('''
          CREATE TABLE ${DBConstant.tblMasterHeader} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE ${DBConstant.tblKaryawan} (
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
          CREATE TABLE ${DBConstant.tblLogMstSync} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
             name TEXT,
             lastUpdate INTEGER     
          )
        ''');

        await db.execute('''
          CREATE TABLE ${DBConstant.tblFPKaryawan} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sn TEXT,
            sensor TEXT,
            idF TEXT,
            nik TEXT,
            nama TEXT,
            template TEXT      
          )
        ''');

        await db.execute('''
          CREATE TABLE ${DBConstant.tblUser} (
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

        // await db.execute('''
        //   CREATE TABLE ${DBConstant.tblUserAccess} (
        //       id INTEGER PRIMARY KEY AUTOINCREMENT,
        //       name TEXT NOT NULL,
        //       nik TEXT,
        //       prev0 INTEGER,
        //       prev1 INTEGER,
        //       prev2 INTEGER,
        //       prev3 INTEGER,
        //       prev4 INTEGER,
        //       prev5 INTEGER,
        //       prev6 INTEGER,
        //       prev7 INTEGER,
        //       prev8 INTEGER,
        //       prev9 INTEGER,
        //       prev10 INTEGER,
        //       prev11 INTEGER,
        //       prev12 INTEGER,
        //       prev13 INTEGER,
        //       prev14 INTEGER
        //   );
        // ''');

        await db.execute('''
          CREATE TABLE ${DBConstant.tblMasterAccess} (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              key TEXT,
              value TEXT
          );
        ''');

        var masterlist = [
          {'name': 'Karyawan'},
        ];

        var iconMenuList = [
          DashboardIconMenuModel(
            menuNm: 'Fingerprint',
            path: '/fingerprint',
            // menuIcon: LucideIcons.fingerprint,
            iconIndex: 1,
          ),
          DashboardIconMenuModel(
            menuNm: 'Ombrometer',
            path: '/ombro',
            // menuIcon: LucideIcons.milk,
            iconIndex: 2,
          ),
          DashboardIconMenuModel(
            menuNm: 'Template',
            path: '/template',
            // menuIcon: LucideIcons.layoutList,
            iconIndex: 3,
          ),
        ];

        var adminDataList = [
          {'key': 'prev0', 'value': 'Tambah akses privilege'},
          {'key': 'prev1', 'value': 'Interval delete otomatis'},
          {'key': 'prev2', 'value': 'Setting extention door'},
          {'key': 'prev3', 'value': 'Setting default fingerprint'},
          {'key': 'prev4', 'value': 'Delete log absen'},
          {'key': 'prev5', 'value': 'Delete data karyawan by nik'},
          {'key': 'prev6', 'value': 'Kirim template finger by nik'},
          {'key': 'prev7', 'value': 'Kirim template'},
          {'key': 'prev8', 'value': 'Simpan template'},
          {'key': 'prev9', 'value': 'Setting jam'},
          {'key': 'prev10', 'value': 'Setting interval upload'},
          {'key': 'prev11', 'value': 'Register Finger'},
          {'key': 'prev12', 'value': 'Factory reset'},
          {'key': 'prev13', 'value': 'Setting wifi dan password'},
          {'key': 'prev14', 'value': 'Setting alamat server'},
        ];

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
          {
            'no': 1,
            'key': 'menit',
            'value': 'Menit',
            'menu': 'fingerprint',
            'submenu': 'datetime'
          },
          {
            'no': 2,
            'key': 'jam',
            'value': 'Jam',
            'menu': 'fingerprint',
            'submenu': 'datetime'
          },
          {
            'no': 3,
            'key': 'hari',
            'value': 'Hari',
            'menu': 'fingerprint',
            'submenu': 'datetime'
          },
          {
            'no': 4,
            'key': 'bulan',
            'value': 'Bulan',
            'menu': 'fingerprint',
            'submenu': 'datetime'
          },
          {
            'no': 5,
            'key': 'tahun',
            'value': 'Tahun',
            'menu': 'fingerprint',
            'submenu': 'datetime'
          },
          {
            'no': 1,
            'key': 'paired',
            'value': 'Paired',
            'menu': 'fingerprint',
            'submenu': 'btconnection'
          },
          {
            'no': 2,
            'key': 'notpaired',
            'value': 'Not Paired',
            'menu': 'fingerprint',
            'submenu': 'btconnection'
          },
          {
            'no': 3,
            'key': 'owl',
            'value': 'OWL',
            'menu': 'fingerprint',
            'submenu': 'btconnection'
          },
        ];

        for (var element in iconMenuList) {
          db.insert(DBConstant.tblDashMenuIcon, element.toMap());
        }
        for (var element in masterlist) {
          db.insert(DBConstant.tblMasterHeader, element);
        }
        for (var element in dropdownlist) {
          db.insert(DBConstant.tblDDList, element);
        }
        for (var element in adminDataList) {
          db.insert(DBConstant.tblMasterAccess, element);
        }
      },
    );
  }
}
