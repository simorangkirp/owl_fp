import 'package:owl_fp/data/model/karyawan.model.dart';

import 'db/karyawan.dbservice.dart';

abstract class MasterLocalDataSource {
  Future<void> syncKaryawan(List<KaryawanModel> list);
  Future<void> deleteKaryawan();
  Future<List<KaryawanModel>?> searchKaryawanArgs(String args);
  Future<void> insertLogSnyc(Map<String, dynamic> args);
  Future<String?> getLog(String args);
}

class MasterLocalDataSourceImpl extends MasterLocalDataSource {
  final KaryawanDBHelper databaseHelper;
  MasterLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> syncKaryawan(List<KaryawanModel> list) async {
    await databaseHelper.syncKaryawan(list);
  }

  @override
  Future<void> deleteKaryawan() async {
    await databaseHelper.deleteAllKaryawan();
  }

  @override
  Future<List<KaryawanModel>?> searchKaryawanArgs(String args) async {
    var res = await databaseHelper.searchKaryawanTuple(args);
    return res;
  }

  @override
  Future<void> insertLogSnyc(Map<String, dynamic> args) async {
    await databaseHelper.addLog(args);
  }

  @override
  Future<String?> getLog(String args) async {
    return await databaseHelper.getLastData(args);
  }
}
