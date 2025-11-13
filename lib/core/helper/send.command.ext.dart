import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/send.command.uc.dart';

extension SendCommandUI on SendCommandUseCase {
  /// Kirim perintah + auto tampil dialog + snackbar
  Future<void> callWithUI({
    required String data,
    required String desc,
    RxBool? doneFlag,
    RxInt? resultCounter,
    bool useRetry = false,
    int maxRetry = 3,
    String? successMsg,
    String? errorMsg,
  }) async {
    // 🔹 tampil dialog loading
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
                const CircularProgressIndicator(),
                SizedBox(height: 24.h),
                Text("Mengirim perintah: $desc"),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });

    // 🔹 kirim command
    try {
      await this(
        data: data,
        desc: desc,
        doneFlag: doneFlag,
        resultCounter: resultCounter,
        useRetry: useRetry,
        maxRetry: maxRetry,
      );

      if (Get.isDialogOpen == true) Get.back();
      if (successMsg != null) {
        Get.snackbar("Sukses", successMsg);
      } else {
        Get.snackbar("Sukses", "Perintah $desc berhasil dikirim");
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar("Error", errorMsg ?? e.toString());
    }
  }
}
