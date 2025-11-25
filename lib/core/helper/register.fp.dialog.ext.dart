import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/register.fp.uc.dart';

extension RegisterFingerUI on RegisterFingerUseCase {
  /// controller passes `data` (string). This extension will parse nik/name
  /// and call the RegisterFingerUseCase.call({nik, name, doneFlag}).
  Future<void> callWithUI({
    required String data,
    required String desc,
    required RxBool doneFlag,
    RxInt? resultCounter,
    String? successMsg,
    String? errorMsg,
  }) async {
    // Parse data string into parts
    // expected formats:
    // register: "r\n<nik>\n<name>\n?\n<auth>"
    // delete:   "5\n<nik>\n?\n<auth>"
    final parts = data.split('\n');

    String nik = "";
    String name = "";

    if (parts.isEmpty) {
      log("RegisterFingerUI: data string empty");
      Get.snackbar("Error", "Data perintah tidak valid");
      return;
    }

    final cmd = parts[0].trim();
    if (cmd == 'r') {
      // register: ensure at least 3 parts: ['r', nik, name, ...]
      if (parts.length < 3) {
        Get.snackbar("Error", "Format perintah registrasi tidak valid");
        return;
      }
      nik = parts[1].trim();
      name = parts[2].trim();
    } else if (cmd == '5') {
      // delete: ['5', nik, '?', auth]
      if (parts.length < 2) {
        Get.snackbar("Error", "Format perintah hapus tidak valid");
        return;
      }
      nik = parts[1].trim();
      name = ""; // delete has no name
    } else {
      // fallback: try to be permissive — attempt to extract nik/name if present
      if (parts.length >= 2) nik = parts[1].trim();
      if (parts.length >= 3) name = parts[2].trim();
    }

    // Show initial "sending" dialog (like SendCommandUI did)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen != true) {
        Get.dialog(
          Dialog(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.2.sh),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 24.h),
                  Text("Mengirim perintah: $desc"),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    });

    try {
      // call the usecase (it expects nik & name)
      await call(
        nik: nik,
        name: name,
        doneFlag: doneFlag,
      );

      // close the initial loading dialog (the usecase itself will show fingerprint dialog & wait for done)
      if (Get.isDialogOpen == true) Get.back();

      if (successMsg != null) {
        log(successMsg);
      } else {
        log("Registrasi/Hapus fingerprint selesai: $desc");
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      log("Error RegisterFingerUI: ${errorMsg ?? e.toString()}");
      rethrow;
    }
  }
}
