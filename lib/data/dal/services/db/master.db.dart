import 'package:owl_fp/data/model/karyawan.model.dart';

import '../db.helper.dart';

abstract class MasterLocalDataSource {
  Future<void> syncKaryawan(List<KaryawanModel> list);
  Future<void> deleteKaryawan();
  Future<List<KaryawanModel>?> searchKaryawanArgs(String args);
}

class MasterLocalDataSourceImpl extends MasterLocalDataSource {
  final DatabaseHelper databaseHelper;
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
}
