import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/domain/entity/dropopt.entity.dart';
import 'package:owl_fp_newer/presentation/ui/common/controller/permission.controller.dart';

import '../../../../core/resources/data.state.dart';
import '../../../../core/resources/utils.dart';
import '../../../../data/dal/services/get.storage.dart';
import '../../../../data/model/mst.admin.model.dart';
import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/usecase/fingerprint/get.admin.ddoptlist.dart';
import '../../../../domain/usecase/fingerprint/get.btstats.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.dt.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/get.mst.admin.dart';
import '../../../../domain/usecase/fingerprint/get.setting.options.dart';
import '../../../../domain/usecase/fingerprint/get.uploaddown.opt.usecase.dart';
import '../../../../domain/usecase/fingerprint/sn.usecase.dart';
import '../../../../domain/usecase/masterdata/find.karyawan.usecase.dart';
import '../../../../domain/usecase/fingerprint/insert.template.dart';
import '../../../../domain/usecase/fingerprint/delete.template.dart';
import '../../../../domain/usecase/fingerprint/get.template.dart';
import '../../../../domain/usecase/fingerprint/send.template.dart';
import '../../login/controllers/login.controller.dart';
import 'bt14_ctrl_controller.dart';

class FingerprintController extends GetxController {
  // -------------------------
  // Dependencies (single Find)
  // -------------------------
  /// NOTE:
  /// Binding registers Bt14CtrlController & PermissionController before this controller
  /// (see your `FingerprintControllerBinding`), so it's safe to `Get.find()` here.
  final Bt14CtrlController btCtrl = Get.find<Bt14CtrlController>();
  final PermissionController permCtrl = Get.find<PermissionController>();

  final FindKaryawanTupleUseCase _searchKaryawan;
  final GetUploadDownloadOptionsUseCase _getUploadDownloadOpt;
  final GetAdminOptionsUseCase _getAdminOpt;
  final GetSettingOptionsUseCase _getSettingOpt;
  final GetDTOptUseCase _getDtOpt;
  final GetBtstatsOptUseCase _getBtstatsOptUseCase;
  final InsertTemplateUseCase _insertTemplateUseCase;
  final DeleteTemplateUseCase _deleteTemplateUseCase;
  final GetSNListUsecase _getSNUsecase;
  final GetDataTemplate _getTemplateData;
  final SendTemplateUseCase _sendTemplateData;
  final GetMasterAdminUsecase _getAdminMasterData;

  FingerprintController(
    this._searchKaryawan,
    this._getUploadDownloadOpt,
    this._getAdminOpt,
    this._getSettingOpt,
    this._getDtOpt,
    this._getBtstatsOptUseCase,
    this._insertTemplateUseCase,
    this._deleteTemplateUseCase,
    this._getSNUsecase,
    this._getTemplateData,
    this._sendTemplateData,
    this._getAdminMasterData,
  );

  // -------------------------
  // Form Keys
  // -------------------------
  final formAddAdminKey = GlobalKey<FormState>();
  final formDeleteNikKey = GlobalKey<FormState>();
  final formGPinKey = GlobalKey<FormState>();
  final formUpdownKey = GlobalKey<FormState>();
  final formRegisterKey = GlobalKey<FormState>();
  final formKeySendTemplateKey = GlobalKey<FormState>();

  // -------------------------
  // Dropdown / Options
  // -------------------------
  var optSetting = <DropOptionEntity>[].obs;
  var opt1 = <String>[].obs;
  var timeOpt = <String>[].obs;
  var uploadDownloadList = <String>[].obs;
  var adminDDOptList = <String>[].obs;

  // Selected option variables
  var selectedSetting = ''.obs;
  var selectedSettingId = 0.obs;
  var selectedOpt1 = ''.obs;
  var selectedUpDown1 = ''.obs;
  var selectedAdmin = ''.obs;
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;

  // -------------------------
  // Other vars
  // -------------------------
  final box = StorageService.instance;
  RxBool isPwObscured = true.obs;

  // -------------------------
  // Boolean states
  // -------------------------
  var devinfSendTmplt = false.obs;
  var devinfResetFp = false.obs;
  var devinfResetMobile = false.obs;
  var doneProcess = false.obs;

  // Upload / download state
  var undselectedMenuIndex = 0.obs;
  var admselectedMenuIndex = 0.obs;

  // -------------------------
  // Admin controllers & fields
  // -------------------------
  final oldpinCtrl = TextEditingController();
  final newpinCtrl = TextEditingController();
  final confpinCtrl = TextEditingController();

  // Typeahead / dialog
  final typeAheadController = TextEditingController()..text = "";
  final taDeleteCtrl = TextEditingController()..text = "";
  final authDialogCtrl = TextEditingController();
  var authDialogArg = "";
  var selectedSN = ''.obs;

  // -------------------------
  // Lists / data
  // -------------------------
  var karyawanlist = <KaryawanEntity>[].obs;
  var listSN = <String>[].obs;
  var dataTemplate = <Map<String, dynamic>>[];
  var listAdminOpt = <MstAdminModel>[].obs;

  // -------------------------
  // Lifecycle
  // -------------------------
  @override
  Future<void> onInit() async {
    super.onInit();
    // preload required data
    await searchData();
    await getDropdownOptionList();
    await getSNList();
    await getMstAdmin();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    // Dispose controllers created here
    oldpinCtrl.dispose();
    newpinCtrl.dispose();
    confpinCtrl.dispose();
    typeAheadController.dispose();
    taDeleteCtrl.dispose();
    authDialogCtrl.dispose();
    super.onClose();
  }

  // -------------------------
  // Usecase / Async functions
  // -------------------------

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
        await tambahAdminPrivilege();
        break;
      case 2:
        await sendTemplateToDevice();
        break;
    }
  }

  Future<void> adminOptSend(int index) async {
    switch (index) {
      case 0:
        await gantiPIN();
        break;
      case 1:
        await tambahAdminPrivilege();
        break;
      case 2:
        await adminHapusbyNik();
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

    ever(doneProcess, (registered) async {
      if (registered == true && Get.isDialogOpen == true) {
        doneProcess.value = false;
        Get.back();
      }
    });

    await uploadTemplateToServer();
  }

  Future<void> uploadTemplateToServer() async {
    log("Ambil Data Dari Local by SN");
    var res = await _getTemplateData.execute(selectedSN.value);
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
      log(box.expToken ?? "");
      late DataState<dynamic> ret;
      var exp = await isTokenExpired(box.expToken);
      if (!exp) {
        log("Token Not Expired Yet");
        ret = await _sendTemplateData.execute(body);
      } else {
        log("Token Expired");
        log("Trying to relog.");
        final loginCtrl = Get.find<LoginController>();
        await loginCtrl.onReLogin();
        ret = await _sendTemplateData.execute(body);
      }
      if (ret.data["error"] == false) {
        doneProcess.value = true;
        showSnackBar("Mengirim data berhasil!");
      } else {
        showSnackBar("Mengirim data gagal!");
      }
    }
  }

  Future<void> sendTemplateToDevice() async {
    await checkPermission(() async {
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

      var data = await _getTemplateData.execute(selectedSN.value);
      if (data.isNotEmpty) {
        log('Total Data: ${data.length}');
        for (var el in data) {
          log("Send Template with NIK : ${el.nik}");
          await btCtrl.sendTemplateByNIK(
              el.nik ?? "", el.template ?? "", authDialogArg);
        }
      } else {
        log("❌ Tidak ada data template ditemukan");
      }

      // Tunggu sampai selesai
      await waitUntilDone(btCtrl.isDone);

      if (Get.isDialogOpen == true) {
        Get.back();
        btCtrl.resetVariables();
      }
    });
  }

  Future<void> insertTemplateLocal(String args) async {
    // Tunggu sampai template selesai diterima
    await btCtrl.getTemplateFromDevice(args);

    // Ambil data template dari controller
    dataTemplate = btCtrl.listInsertTemplate;

    if (dataTemplate.isEmpty) {
      log("❌ Tidak ada template diterima");
      return;
    }

    // Hapus template lama
    final sn = dataTemplate.first['sn'];
    log("Delete data finger by SN: $sn");
    await _deleteTemplateUseCase.execute(sn);

    // Insert template baru
    log("Insert data to finger");
    await _insertTemplateUseCase.execute(dataTemplate);

    // Reset Variable
    log("Reset variable");
    return await btCtrl.resetVariables();
  }

  Future<void> getDropdownOptionList() async {
    uploadDownloadList.value =
        await _getUploadDownloadOpt.execute('downloadupload');
    optSetting.value = await _getSettingOpt.execute('setting');
    timeOpt.value = await _getDtOpt.execute('datetime');
    opt1.value = await _getBtstatsOptUseCase.execute('btconnection');
    adminDDOptList.value = await _getAdminOpt.execute('admin');
  }

  Future<void> getSNList() async {
    listSN.value = await _getSNUsecase.execute();
    for (var el in listSN) {
      log(el);
    }
  }

  Future<void> tambahAdminPrivilege() async {
    String access = "";
    for (var el in listAdminOpt) {
      if (el.selected.value) {
        access = '${access}1';
      } else {
        access = '${access}0';
      }
    }
    await btCtrl.addAdminPrivileges(access, authDialogArg, "");
    await btCtrl.resetVariables();
    authDialogCtrl.clear();
    authDialogArg = "";
  }

  Future<void> adminHapusbyNik() async {
    await btCtrl.regDelFinger(
      isRegister: false, // false kalau hapus
      nik: btCtrl.selectedRegisterNIK, // pakai variable dari controller
      name: btCtrl.selectedRegisterNm, // pakai variable dari controller
      auth: authDialogArg,
    );
    authDialogCtrl.clear();
    await btCtrl.resetVariables();
    authDialogArg = "";
  }

  Future<void> gantiPIN() async {
    if (oldpinCtrl.text == confpinCtrl.text) {
      await btCtrl.gantiPIN(newpinCtrl.text, authDialogArg);
      await btCtrl.resetVariables();
    } else {
      Get.snackbar(
        '',
        "PIN Baru tidak sama",
        titleText: const SizedBox.shrink(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
    authDialogCtrl.clear();
    newpinCtrl.clear();
    oldpinCtrl.clear();
    confpinCtrl.clear();
    authDialogArg = "";
  }

  /// Centralized permission + connection check
  Future<void> checkPermission(
    Function onGranted, {
    bool requireConnectedDevice = true,
  }) async {
    log("Selected: ${btCtrl.selectedDevice.value}, IsCon: ${btCtrl.isConnected.value}, ReqCon: $requireConnectedDevice");

    await permCtrl.checkBtAdaptor();
    if (!permCtrl.bluetoothAdaptor.value) {
      showSnackBar("Adaptor Bluetooth tidak ditemukan atau belum aktif.");
      return;
    }

    await permCtrl.requestBluetoothPermission();
    if (!permCtrl.bluetoothGranted.value) {
      showSnackBar("Mohon izinkan akses Bluetooth terlebih dahulu.");
      return;
    }

    if (requireConnectedDevice) {
      if (btCtrl.selectedDevice.value == null || !btCtrl.isConnected.value) {
        showSnackBar("Belum ada perangkat Bluetooth yang terhubung.");
        return;
      }
    }

    await onGranted();
  }

  // -------------------------
  // Utility / Reset
  // -------------------------
  Future<void> resetLocalStateAfterOp() async {
    authDialogCtrl.clear();
    authDialogArg = "";
  }
}
