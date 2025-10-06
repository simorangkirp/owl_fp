import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data.state.dart';

Future<bool> isTokenExpired(String? datetime) async {
  if (datetime != null) {
    try {
      DateTime expireTime = DateTime.parse(datetime);
      if (DateTime.now().isAfter(expireTime)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Kalau parsing gagal
      return false;
    }
  } else {
    return false;
  }
}

showSnackBar(String msg) {
  return Get.snackbar(
    '',
    msg,
    titleText: const SizedBox.shrink(),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.black87,
    colorText: Colors.white,
    duration: const Duration(seconds: 2), // Supaya tidak hilang otomatis
    margin: const EdgeInsets.all(12),
  );
}

class DialogHelper {
  /// 🔹 Tampilkan dialog loading dengan progress bar step
  static void showLoadingStep(int step, String title, int totalStep) {
    if (Get.isDialogOpen == true) Get.back();

    final progress = step / totalStep;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 0.78.sw, // biar konsisten ukurannya
          height: 0.14.sh,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Step $step/$totalStep: $title",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 6,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// 🔹 Tutup dialog jika masih terbuka
  static void closeDialog() {
    if (Get.isDialogOpen == true) Get.back();
  }

  /// 🔹 Handle hasil API → otomatis nutup dialog + show snackbar
  static void handleApiResult(
    DataState result, {
    Function(dynamic data)? onSuccess,
    String successMessage = "Berhasil",
    String errorMessage = "Terjadi kesalahan",
  }) {
    closeDialog();

    if (result is DataSuccess) {
      final data = result.data;

      if (onSuccess != null && data != null) {
        onSuccess(data);
      }

      Get.snackbar(
        '',
        successMessage,
        titleText: const SizedBox.shrink(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    } else if (result is DataError) {
      Get.snackbar(
        '',
        "${result.error ?? errorMessage}",
        titleText: const SizedBox.shrink(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  /// 🔹 Notifikasi kecil kalau lagi retry request
  static void showRetrySnack(int retry, int maxRetry) {
    Get.snackbar(
      '',
      "⏳ Timeout, coba ulang ($retry/$maxRetry)...",
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }
}

String extractErrorMessage(Object? error) {
  if (error == null) return 'Terjadi kesalahan';

  // 1) Kalau error sudah String
  if (error is String && error.isNotEmpty) return error;

  // 2) Kalau API mengembalikan map dengan key message
  if (error is Map) {
    if (error.containsKey('message')) {
      return error['message']?.toString() ?? error.toString();
    }
    return error.toString();
  }

  // 3) Jika Dio v4 DioError
  if (error is DioError) {
    // Prefer response.data.message bila tersedia
    final resp = error.response;
    if (resp?.data != null) {
      final d = resp!.data;
      if (d is Map && d.containsKey('message')) {
        return d['message']?.toString() ?? d.toString();
      }
      return d.toString();
    }
    // fallback ke message/error/toString
    return error.message;
  }

  // 4) Kalau ada custom error object yang punya field `message` (try safe)
  try {
    final dynamic e = error;
    if (e?.message != null) return e.message.toString();
  } catch (_) {}

  // 5) Default fallback
  return error.toString();
}

Future<void> waitUntilDone(RxBool flag,
    {Duration timeout = const Duration(seconds: 15)}) async {
  final start = DateTime.now();
  await Future.doWhile(() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final elapsed = DateTime.now().difference(start);
    if (elapsed > timeout) {
      log("⚠️ Timeout menunggu flag done");
      return false;
    }
    return !flag.value;
  });
}
