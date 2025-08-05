import 'package:owl_fp/data/model/profile.model.dart';

import '../db.helper.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> user();
}

class ProfileLocalDataSourceImpl extends ProfileLocalDataSource {
  final DatabaseHelper databaseHelper;
  ProfileLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<ProfileModel> user() async {
    var response = await databaseHelper.getUser();
    if (response!.isNotEmpty) {
      return ProfileModel.fromJson(response);
    } else {
      return const ProfileModel(
          name: 'name',
          sex: 'sex',
          birthday: 'birthday',
          birthplace: 'birthplace',
          address: 'address',
          noktp: 'noktp',
          nopaspor: 'nopaspor',
          nationality: 'nationality',
          religion: 'religion',
          statusperkawinan: 'statusperkawinan',
          kodejabatan: 'kodejabatan',
          jabatan: 'jabatan',
          bagian: 'bagian',
          tipekaryawan: 'tipekaryawan',
          kodeorganisasi: 'kodeorganisasi',
          namaorganisasi: 'namaorganisasi',
          lokasitugas: 'lokasitugas',
          tipelokasitugas: 'tipelokasitugas',
          subbagian: 'subbagian',
          kodeorganisasiTemp: 'kodeorganisasiTemp',
          namaorganisasiTemp: 'namaorganisasiTemp',
          lokasitugasTemp: 'lokasitugasTemp',
          tipelokasitugasTemp: 'tipelokasitugasTemp',
          subbagianTemp: 'subbagianTemp',
          poh: 'poh',
          signdate: 'signdate',
          resigndate: 'resigndate',
          sistemgaji: 'sistemgaji',
          email: 'email',
          phone: 'phone',
          regional: 'regional');
    }
  }
}
