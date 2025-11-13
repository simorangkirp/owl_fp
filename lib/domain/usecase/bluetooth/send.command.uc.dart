import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/data/dal/daos/bluetooth/bt.repoimpl.dart';

class SendCommandUseCase {
  final BluetoothRepositoryImpl repository;

  SendCommandUseCase(this.repository);

  /// Universal sender untuk semua command Bluetooth
  Future<void> call({
    required String data,
    String? desc,
    bool showDialog = true,
    bool waitForResponse = true,
    bool useRetry = false,
    int maxRetry = 3,
    Duration timeout = const Duration(seconds: 10),
    RxBool? doneFlag,
    RxInt? resultCounter,
  }) async {
    int attempt = 0;
    bool success = false;

    if (showDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.dialog(
          Dialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.1, vertical: Get.height * 0.2),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text("Mengirim perintah: ${desc ?? 'Bluetooth Command'}"),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      });
    }

    while (!success && (attempt < maxRetry)) {
      attempt++;
      log("📤 [Attempt $attempt/$maxRetry] ${desc ?? data}");

      try {
        final connected = await repository.isConnected();
        if (!connected) {
          Get.snackbar("Error", "Device belum terhubung");
          break;
        }

        final ok = await repository.sendCommand(data, desc: desc);
        if (!ok) {
          log("❌ Write failed attempt $attempt");
          if (!useRetry) break;
          await Future.delayed(const Duration(milliseconds: 300));
          continue;
        }

        if (waitForResponse) {
          bool gotResponse = await _waitForResponse(
            doneFlag: doneFlag,
            resultCounter: resultCounter,
            timeout: timeout,
          );
          if (gotResponse) {
            success = true;
            log("✅ Respons diterima untuk ${desc ?? data}");
          } else {
            log("⚠️ Timeout menunggu respons untuk ${desc ?? data}");
          }
        } else {
          success = true;
        }
      } catch (e, st) {
        log("❌ Exception saat kirim ${desc ?? data}: $e\n$st");
      }

      if (useRetry && !success) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    if (Get.isDialogOpen == true) Get.back();

    if (!success) {
      log("🚨 Gagal kirim ${desc ?? data} setelah $maxRetry percobaan");
      Get.snackbar("Error", "Gagal kirim ${desc ?? data}");
    }
  }

  Future<bool> _waitForResponse({
    RxBool? doneFlag,
    RxInt? resultCounter,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final start = DateTime.now();
    final baseCounter = resultCounter?.value ?? 0;

    while (DateTime.now().difference(start) < timeout) {
      await Future.delayed(const Duration(milliseconds: 200));

      if (doneFlag?.value == true) {
        return true;
      }
      if (resultCounter != null && resultCounter.value > baseCounter) {
        return true;
      }
    }

    return false;
  }
}
