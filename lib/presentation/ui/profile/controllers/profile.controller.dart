import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owl_fp_newer/core/resources/data.state.dart';
import 'package:owl_fp_newer/domain/entity/profile.entity.dart';

import '../../../../core/resources/utils.dart';
import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/usecase/masterdata/master.usecase.dart';
import '../../../../domain/usecase/profile/getuser.usecase.dart';
import '../../login/controllers/login.controller.dart';

class ProfileController extends GetxController {
  final GetUserUseCase _profileUseCase;
  final SyncMasterDataUseCase _syncMDUseCase;
  ProfileController(this._profileUseCase, this._syncMDUseCase);

  // Others
  final storage = Get.find<StorageService>();

  // Variables
  var users = Rxn<ProfileEntity>();
  var ip = "".obs;

  // Booleans
  RxBool isDone = false.obs;
  RxBool openLang = false.obs;
  RxBool openTheme = false.obs;

  Future<void> getUser() async {
    var res = await _profileUseCase.execute();
    users.value = res;
  }

  Future<void> syncMD() async {
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
    var exp = await isTokenExpired(storage.expToken);
    late DataState<dynamic> res;
    if (!exp) {
      log("Token Not Expired Yet");
      res = await _syncMDUseCase.execute();
    } else {
      log("Token Expired");
      log("Trying to relog.");
      final loginCtrl = Get.find<LoginController>();
      await loginCtrl.onReLogin().then((value) async {
        res = await _syncMDUseCase.execute();
      });
    }

    isDone.value = true;
    if (res.data["error"] == false) {
      showSnackBar("Sinkronisasi Berhasil!");
    } else {
      showSnackBar("Sinkronisasi Gagal!");
    }
  }

  Future<void> confirmDialog() async {
    Get.dialog(
      AlertDialog(
        titlePadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        contentPadding: EdgeInsets.only(left: 12.w, right: 12.w),
        actionsPadding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
        title: Text('masterdataSync'.tr,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center),
        content: Text('syncMstDataDialogBody'.tr, textAlign: TextAlign.center),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("cancel".tr)),
          TextButton(
              onPressed: () {
                isDone.value = false;
                Get.back();
                syncMD();
              },
              child: Text("confirm".tr)),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Future<void> logOut() async {
    await storage.removeToken();
    await storage.saveIsLoggedIn(false);
    Get.offAllNamed('/login');
  }

  @override
  Future<void> onInit() async {
    await getUser();
    ip.value = storage.bUrl ?? "";
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
