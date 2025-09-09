import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_fp/domain/entity/dropopt.entity.dart';

import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/usecase/fingerprint/get.btstats.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.dt.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.setting.options.dart';
import '../../../../domain/usecase/fingerprint/get.uploaddown.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/sn.usecase.dart';
import '../../../../domain/usecase/masterdata/find.karyawan.usecase.dart';
import '../../../../domain/usecase/fingerprint/insert.template.dart';
import '../../../../domain/usecase/fingerprint/delete.template.dart';
import '../../../../domain/usecase/fingerprint/get.template.dart';
import '../../../../domain/usecase/fingerprint/send.template.dart';
import 'bt.controller.dart';

class FingerprintController extends GetxController {
  final FindKaryawanTupleUseCase _searchKaryawan;
  final GetUploadDownloadOptionsUseCase _getUploadDownloadOpt;
  final GetSettingOptionsUseCase _getSettingOpt;
  final GetDTOptUseCase _getDtOpt;
  final GetBtstatsOptUseCase _getBtstatsOptUseCase;
  final InsertTemplateUseCase _insertTemplateUseCase;
  final DeleteTemplateUseCase _deleteTemplateUseCase;
  final GetSNListUsecase _getSNUsecase;
  final GetDataTemplate _getTemplateData;
  final SendTemplateUseCase _sendTemplateData;
  // final GetSNListUsecase _getSNUsecase;
  FingerprintController(
    this._searchKaryawan,
    this._getUploadDownloadOpt,
    this._getSettingOpt,
    this._getDtOpt,
    this._getBtstatsOptUseCase,
    this._insertTemplateUseCase,
    this._deleteTemplateUseCase,
    this._getSNUsecase,
    this._getTemplateData,
    this._sendTemplateData,
  );

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
  // Upload And Download Template
  var undselectedMenuIndex = 0.obs;

  // Variabels
  var typeAheadController = TextEditingController()..text = "";
  var authDialogCtrl = TextEditingController();
  var authDialogArg = "";
  var selectedSN = ''.obs;

  // List Karyawan
  var karyawanlist = <KaryawanEntity>[].obs;
  var listSN = <String>[].obs;

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

  Future<void> uploadDownloadOptSend(int index) async {
    switch (index) {
      case 0:
        await insertTemplateLocal(authDialogArg);
        break;
      case 1:
        break;
      case 2:
        await uploadTemplateToServer();
        break;
    }
  }

  Future<void> uploadTemplateToServer() async {
    //! Ambil Data Dari Local by SN
    var res = await _getTemplateData.execute(selectedSN.value);
    for (var element in res) {
      log(element.nama ?? "-");
    }
    final box = StorageService();
    if (res.isNotEmpty) {
      var bodyTemplate = res.map((el) => el.template ?? "").join(",");
      var bodySn = res.map((el) => el.sn ?? "").join(",");
      var bodyNik = res.map((el) => el.nik ?? "").join(",");
      var body = {
        "method": "detail",
        "template": bodyTemplate,
        "serialnumber": bodySn,
        "nik": bodyNik,
        "kebun": box.kebun
      };
      //! Kirim Ke Server
      // var send = await _sendTemplateData.execute(body);
    }
  }

  Future<void> insertTemplateLocal(String args) async {
    final btC = Get.find<BluetoothController>();
    await btC.devSend(args);
    do {
      await btC.cekbouncer();
    } while (!btC.isDone.value);
    // await _deleteTemplateUseCase.execute(dataTemplate.first['sn']);
    return await _insertTemplateUseCase.execute(dataTemplate);
  }

  Future<void> getDropdownOptionList() async {
    uploadDownloadList.value =
        await _getUploadDownloadOpt.execute('downloadupload');
    optSetting.value = await _getSettingOpt.execute('setting');
    timeOpt.value = await _getDtOpt.execute('datetime');
    opt1.value = await _getBtstatsOptUseCase.execute('btconnection');
  }

  Future<void> getSNList() async {
    // await _tempCtrl.getSN();
    // if (_tempCtrl.listSN.isNotEmpty) {
    listSN.value = await _getSNUsecase.execute();
    // }
  }

  Future<void> tambahAdmin() async {
    final btC = Get.find<BluetoothController>();
    authDialogCtrl.clear();
    await btC.addAdmin(authDialogArg);
    authDialogArg = "";
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
    await getSNList();
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
