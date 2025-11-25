import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_fp_newer/data/dal/daos/bluetooth/bt.repoimpl.dart';

class RegisterFingerUseCase {
  final BluetoothRepositoryImpl repository;

  RegisterFingerUseCase(this.repository);

  Future<void> call({
    required String nik,
    required String name,
    required RxBool doneFlag,
  }) async {
    // Reset status
    doneFlag.value = false;

    // Siapkan data format mesin
    final payload = "r\n$nik\n$name\n?\n1234"; // auth optional

    // Tampilkan dialog fingerprint
    _showFingerprintDialog(doneFlag);

    // Kirim command register
    await _sendRegisterCommand(payload);

    // Tunggu sampai mesin setuju / selesai
    await _waitUntilDone(doneFlag);

    // Tutup dialog
    if (Get.isDialogOpen == true) Get.back();

    log("Fingerprint berhasil diregistrasi untuk $nik - $name");
  }

  // ==========================================================
  // 🛰️  SEND COMMAND
  // ==========================================================
  Future<void> _sendRegisterCommand(String data) async {
    try {
      final connected = await repository.isConnected();
      if (!connected) {
        Get.snackbar("Error", "Device belum terhubung");
        return;
      }

      final ok = await repository.sendCommand(data, desc: "Register Finger");
      if (!ok) {
        Get.snackbar("Error", "Gagal mengirim perintah ke mesin");
      }
    } catch (e, st) {
      log("❌ Error mengirim command fingerprint: $e\n$st");
    }
  }

  // ==========================================================
  // 🕒 WAIT UNTIL DONE
  // ==========================================================
  Future<void> _waitUntilDone(RxBool doneFlag) async {
    final completer = Completer();

    final worker = ever(doneFlag, (v) {
      if (v == true && !completer.isCompleted) {
        completer.complete();
      }
    });

    await completer.future;
    worker.dispose();
  }

  // ==========================================================
  // 🖼️ UI DIALOG
  // ==========================================================
  void _showFingerprintDialog(RxBool doneFlag) {
    Get.dialog(
      Dialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.2.sh),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fingerprint, size: 72),
                SizedBox(height: 20.h),
                Text(
                  doneFlag.value
                      ? "Fingerprint selesai!"
                      : "Tempelkan jari pada sensor...",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                if (!doneFlag.value) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
