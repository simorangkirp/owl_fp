import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_fp/domain/entity/dropopt.entity.dart';

import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/usecase/fingerprint/get.btstats.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.dt.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.setting.options.dart';
import '../../../../domain/usecase/fingerprint/get.uploaddown.opt.usecase.dart';
import '../../../../domain/usecase/masterdata/find.karyawan.usecase.dart';
import '../../../../domain/usecase/fingerprint/insert.template.dart';
import 'bt.controller.dart';

class FingerprintController extends GetxController {
  final FindKaryawanTupleUseCase _searchKaryawan;
  final GetUploadDownloadOptionsUseCase _getUploadDownloadOpt;
  final GetSettingOptionsUseCase _getSettingOpt;
  final GetDTOptUseCase _getDtOpt;
  final GetBtstatsOptUseCase _getBtstatsOptUseCase;
  final InsertTemplateUseCase _insertTemplateUseCase;
  FingerprintController(
      this._searchKaryawan,
      this._getUploadDownloadOpt,
      this._getSettingOpt,
      this._getDtOpt,
      this._getBtstatsOptUseCase,
      this._insertTemplateUseCase);

  /// Dropdown Option List
  var optSetting = <DropOptionEntity>[].obs;
  var opt1 = <String>[].obs;
  var timeOpt = <String>[].obs;
  var uploadDownloadList = <String>[].obs;

  ///
  /// Selected Option Variables
  var selectedSetting = ''.obs;
  var selectedSettingId = 0.obs;
  var selectedOpt1 = ''.obs;
  var selectedUpDown1 = ''.obs;
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;
  var selectedtod = ''.obs;
  var selectedDt = ''.obs;

  ///
  /// Other Variables
  TimeOfDay tod = TimeOfDay.now();
  DateTime dt = DateTime.now();

  ///
  /// Boolean Variables
  var devinfSendTmplt = false.obs;
  var devinfResetFp = false.obs;
  var devinfResetMobile = false.obs;

  ///

  // Variabels
  var typeAheadController = TextEditingController()..text = "";
  var authDialogCtrl = TextEditingController();
  var authDialogArg = "";

  // List Karyawan
  var karyawanlist = <KaryawanEntity>[].obs;

  // List Data Template
  var dataTemplate = <Map<String, dynamic>>[];

  ///  Asyncronous Function List
  Future<List<KaryawanEntity>?> searchData() async {
    var res = await _searchKaryawan.execute(typeAheadController.text);
    if (res != null) {
      karyawanlist.value = res;
    }
    return res;
  }

  Future<void> insertTemplateLocal(String args) async {
    final btC = Get.find<BluetoothController>();
    await btC.devSend(args);
    do {
      btC.cekbouncer();
    } while (!btC.isDone.value);
    return await _insertTemplateUseCase.execute(dataTemplate);
  }

  Future<void> getDropdownOptionList() async {
    uploadDownloadList.value =
        await _getUploadDownloadOpt.execute('downloadupload');
    optSetting.value = await _getSettingOpt.execute('setting');
    timeOpt.value = await _getDtOpt.execute('datetime');
    opt1.value = await _getBtstatsOptUseCase.execute('btconnection');
  }

  /// Syncronous Funtion List
  void changeTod(TimeOfDay value) {
    selectedtod.value = '${value.hour}:${value.minute}';
  }

  void changeDt(DateTime value) {
    selectedDt.value = '${value.day}/${value.month}/${value.year}';
  }

  @override
  Future<void> onInit() async {
    await searchData();
    await getDropdownOptionList();
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
