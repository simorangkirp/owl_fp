import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/usecase/masterdata/find.karyawan.usecase.dart';

class SettingListModel {
  String nm;
  int id;
  SettingListModel(this.nm, this.id);
}

class FingerprintController extends GetxController {
  final FindKaryawanTupleUseCase _searchKaryawan;
  FingerprintController(this._searchKaryawan);

  var optSetting = <SettingListModel>[
    SettingListModel('Wifi', 0),
    SettingListModel('Waktu Upload', 1),
    SettingListModel('Client ID', 2),
    SettingListModel('Alamat Server', 3),
    SettingListModel('Tanggal & Jam', 4),
    SettingListModel('Waktu Delete Absen', 5),
  ].obs;
  var selectedSetting = ''.obs;
  var selectedSettingId = 0.obs;
  var timeOpt = <String>[
    'menit',
    'jam',
    'hari',
    'bulan',
    'tahun',
  ].obs;
  TimeOfDay tod = TimeOfDay.now();
  DateTime dt = DateTime.now();
  var opt1 = <String>[
    'Paired',
    'Not Paired',
    'OWL',
  ];
  var selectedOpt1 = ''.obs;
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;
  var selectedtod = ''.obs;
  var selectedDt = ''.obs;

  // Variabels
  var typeAheadController = TextEditingController()..text = "";

  // List Karyawan
  var karyawanlist = <KaryawanEntity>[].obs;

  // Function List
  Future<List<KaryawanEntity>?> searchData() async {
    var res = await _searchKaryawan.execute(typeAheadController.text);
    if (res != null) {
      karyawanlist.value = res;
    }
    return res;
  }

  changeTod(TimeOfDay value) {
    selectedtod.value = '${value.hour}:${value.minute}';
  }

  changeDt(DateTime value) {
    selectedDt.value = '${value.day}/${value.month}/${value.year}';
  }

  @override
  Future<void> onInit() async {
    await searchData();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }
}
