import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp/domain/entity/dropopt.entity.dart';

import '../../../../data/dal/services/get.storage.dart';
import '../../../../data/model/mst.admin.model.dart';
import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/usecase/fingerprint/get.btstats.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.dt.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.mst.admin.dart';
import '../../../../domain/usecase/fingerprint/get.setting.options.dart';
import '../../../../domain/usecase/fingerprint/get.uploaddown.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/sn.usecase.dart';
// import '../../../../domain/usecase/fingerprint/upload.tofinger.dart';
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
  final GetMasterAdminUsecase _getAdminMasterData;
  // final SendTemplateToDeviceUsecase _sendTempToDevice;
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
    this._getAdminMasterData,
    // this._sendTempToDevice,
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
  var selectedtod = 'hh:ss'.obs;
  var selectedDt = 'dd/MM/yyyy'.obs;

  ///
  /// Other Variables
  TimeOfDay tod = TimeOfDay.now();
  DateTime dt = DateTime.now();

  ///
  /// Boolean Variables
  var devinfSendTmplt = false.obs;
  var devinfResetFp = false.obs;
  var devinfResetMobile = false.obs;
  var doneProcess = false.obs;

  ///
  // Upload And Download Template
  var undselectedMenuIndex = 0.obs;

  // Variabels
  var typeAheadController = TextEditingController()..text = "";
  var taDeleteCtrl = TextEditingController()..text = "";
  var authDialogCtrl = TextEditingController();
  var pinCtrl = TextEditingController();
  var pinArg = "";
  var authDialogArg = "";
  var selectedSN = ''.obs;

  // List
  var karyawanlist = <KaryawanEntity>[].obs;
  var listSN = <String>[].obs;
  var dataTemplate = <Map<String, dynamic>>[];
  var listAdminOpt = <MstAdminModel>[].obs;

  ///  Asyncronous Function List
  Future<void> getMstAdmin() async {
    listAdminOpt.value = await _getAdminMasterData.execute();
    for (var element in listAdminOpt) {
      log(element.key ?? "");
    }
  }

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
        log("Download Template dari Finger");
        await insertTemplateLocal(authDialogArg);
        break;
      case 1:
        break;
      case 2:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.dialog(
            Dialog(
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.2.sh),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 24.h),
                    Text("Mengirimkan data!.")
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );
        });
        // Pantau kondisi isRegistered dan tutup dialog jika true
        ever(doneProcess, (registered) async {
          if (registered == true && Get.isDialogOpen == true) {
            doneProcess.value = false;
            Get.back(); // menutup dialog
          }
        });
        await sendTemplateToDevice();
        break;
    }
  }

  Future<void> uploadTempToServerDialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.2.sh),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 24.h),
                Text("Mengirimkan data!.")
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });
    // Pantau kondisi isRegistered dan tutup dialog jika true
    ever(doneProcess, (registered) async {
      if (registered == true && Get.isDialogOpen == true) {
        doneProcess.value = false;
        Get.back(); // menutup dialog
      }
    });
    await uploadTemplateToServer();
  }

  Future<void> uploadTemplateToServer() async {
    //! Ambil Data Dari Local by SN
    var res = await _getTemplateData.execute(selectedSN.value);
    // for (var element in res) {
    //   log(element.nama ?? "-");
    // }
    final box = StorageService.instance;
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
      var send = await _sendTemplateData.execute(body);
      if (send.data['error'] != "false") {
        doneProcess.value = true;
      }
    }
  }

  Future<void> sendTemplateToDevice() async {
    final btC = Get.find<BluetoothController>();
    var data = await _getTemplateData.execute(selectedSN.value);
    if (data.isNotEmpty) {
      log('Total Data: ${data.length}');
      for (var el in data) {
        log("Send Template with NIK : ${el.nik}");
        await btC.sendTemplByNik(el.nik ?? "", el.template ?? "");
      }
      doneProcess.value = true;
    }
  }

  // Future<void> insertTemplateLocal(String args) async {
  //   final btC = Get.find<BluetoothController>();
  //   await btC.getTemplateFromDevice(args);
  //   do {
  //     await btC.cekbouncer();
  //   } while (!btC.isDone.value);
  //   await _deleteTemplateUseCase.execute(dataTemplate.first['sn']);
  //   return await _insertTemplateUseCase.execute(dataTemplate);
  // }

  Future<void> insertTemplateLocal(String args) async {
    final btC = Get.find<BluetoothController>();
    await btC.getTemplateFromDevice(args);

    // await _waitUntilDone(btC);
    do {
      // await _processBuffer();
      await Future.delayed(
          const Duration(milliseconds: 100)); // biar ga ngegas CPU
      log("Isdone satus: ${btC.isDone.value}");
    } while (!btC.isDone.value);

    // if (!(btC.debounceTimer?.isActive ?? false)) {
    dataTemplate = btC.listInsertTemplate;
    log("Delete data finger by SN: ${dataTemplate.first['sn']}");
    await _deleteTemplateUseCase.execute(dataTemplate.first['sn']);
    btC.isDone.value = true;
    log("Insert data to finger");
    return await _insertTemplateUseCase.execute(dataTemplate);
    // }
  }

  // /// Helper: bikin Future yang selesai pas isDone true
  // Future<void> _waitUntilDone(BluetoothController btC) {
  //   final completer = Completer<void>();

  //   ever(btC.isDone, (val) {
  //     if (val == true && !completer.isCompleted) {
  //       completer.complete();
  //     }
  //   });

  //   return completer.future;
  // }

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
    for (var el in listSN) {
      log(el);
    }
    // }
  }

  Future<void> tambahAdmin(String arg) async {
    final btC = Get.find<BluetoothController>();
    authDialogCtrl.clear();
    String access = "";
    for (var el in listAdminOpt) {
      if (el.selected.value) {
        access = '${access}1';
      } else {
        access = '${access}0';
      }
    }
    await btC.addAdmin(access, arg);
    authDialogArg = "";
  }

  Future<void> gantiPIN() async {
    final btC = Get.find<BluetoothController>();
    authDialogCtrl.clear();
    await btC.gantiPIN(pinArg, authDialogArg);
    pinCtrl.clear();
    authDialogArg = "";
    pinArg = "";
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
    await getMstAdmin();
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
