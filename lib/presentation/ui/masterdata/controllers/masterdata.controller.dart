import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/resources/data.state.dart';
import '../../../../core/resources/utils.dart';
import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/entity/karyawan.entity.dart';
import '../../../../domain/usecase/masterdata/find.karyawan.usecase.dart';
import '../../../../domain/usecase/masterdata/get.log.master.dart';
import '../../../../domain/usecase/masterdata/sync.mst.karyawan.dart';
import '../../../constant.dart';
import '../../login/controllers/login.controller.dart';

class MasterdataController extends GetxController {
  final FindKaryawanTupleUseCase _searchKaryawan;
  final OnSyncMstKaryawanUsecase _onSyncKaryawan;
  final GetLogMasterUsecase _getLogMaster;
  MasterdataController(
    this._searchKaryawan,
    this._onSyncKaryawan,
    this._getLogMaster,
  );
  // Variabels
  var title = "".obs;
  var karyawanlist = <KaryawanEntity>[].obs;
  var lastUpdate = "".obs;

  // Others
  final storage = Get.find<StorageService>();

  // Rxbool
  RxBool isDone = false.obs;

  // Text Controller
  var searchCtrl = TextEditingController();

  // Function List
  Future<List<KaryawanEntity>?> searchData() async {
    var res = await _searchKaryawan.execute(searchCtrl.text);
    if (res != null) {
      karyawanlist.value = res;
    }
    return res;
  }

  Future<void> getLastUpdate(String args) async {
    lastUpdate.value = await _getLogMaster.execute(args) ?? "";
  }

  Future<void> onSyncKaryawan() async {
    isDone.value = false;
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sinkron Master Data',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24.h),
              const CircularProgressIndicator(),
              SizedBox(height: 12.h),
              const Text(
                'Sinkronisasi master data.',
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Pantau kondisi login
    ever(isDone, (val) async {
      if (val == true && Get.isDialogOpen == true) {
        Get.back(); // tutup dialog
      }
    });
    log(storage.expToken ?? "");
    late DataState<dynamic> res;
    var exp = await isTokenExpired(storage.expToken);
    if (!exp) {
      log("Token Not Expired Yet");
      res = await _onSyncKaryawan.execute();
      await getLastUpdate(LogConstant.mstKaryawan);
    } else {
      log("Token Expired");
      log("Trying to relog.");
      final loginCtrl = Get.find<LoginController>();
      await loginCtrl.onReLogin();
      res = await _onSyncKaryawan.execute();
      await getLastUpdate(LogConstant.mstKaryawan);
    }
    isDone.value = true;
    if (res.data["error"] == false) {
      showSnackBar("Sinkronisasi Berhasil!");
    } else {
      showSnackBar("Sinkronisasi Gagal!");
    }
  }

  @override
  void onInit() async {
    title.value = Get.arguments['args'] ?? "Undefined";
    await getLastUpdate(LogConstant.mstKaryawan);
    await searchData();
    // for (var element in karyawanlist) {
    //   log(element.namakaryawan ?? "");
    // }
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
