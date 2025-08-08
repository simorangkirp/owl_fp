import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owl_fp/domain/entity/karyawan.entity.dart';
import 'package:owl_fp/domain/entity/profile.entity.dart';

import '../../../../data/dal/services/get.storage.dart';
import '../../../../domain/usecase/masterdata/master.usecase.dart';
import '../../../../domain/usecase/profile/getuser.usecase.dart';

class ProfileController extends GetxController {
  final GetUserUseCase _profileUseCase;
  final SyncMasterDataUseCase _syncMDUseCase;
  ProfileController(this._profileUseCase, this._syncMDUseCase);

  var users = Rxn<ProfileEntity>();

  Future<void> getUser() async {
    var res = await _profileUseCase.execute();
    users.value = res;
  }

  Future<void> syncMD() async {
    await _syncMDUseCase.execute();
  }

  Future<void> confirmDialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        AlertDialog(
          titlePadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          contentPadding: EdgeInsets.only(left: 12.w, right: 12.w),
          actionsPadding:
              EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
          title: Text(
            'Sinkronisasi Master Data',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text('Apa anda yakin mau sinkronisasi Master Data?'),
          actions: [
            TextButton(onPressed: () {}, child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  Get.back();
                  syncMD();
                },
                child: Text("Confirm")),
          ],
        ),
        barrierDismissible: true,
      );
    });
  }

  Future<void> logOut() async {
    var box = StorageService();
    await box.removeToken();
    await box.saveIsLoggedIn(false);
    Get.offAllNamed('/login');
  }

  @override
  Future<void> onInit() async {
    await getUser();
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
