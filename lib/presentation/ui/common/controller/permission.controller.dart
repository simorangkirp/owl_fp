import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_fp_newer/core/services/bluetooth.service.dart';
import 'package:owl_fp_newer/core/services/permission.service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  final bluetoothGranted = false.obs;
  final bluetoothAdaptor = false.obs;

  Future<void> checkBtAdaptor() async {
    // 🔥 WAJIB: pastikan permission granted sebelum apapun
    await requestBluetoothPermission();

    if (!bluetoothGranted.value) {
      log('❌ Permission belum diberikan, stop.');
      return;
    }

    // Setelah permission OK → baru boleh cek status Bluetooth
    final isEnabled = await FlutterBluetoothClassic.isBluetoothEnabled();

    if (isEnabled) {
      bluetoothAdaptor.value = true;
      log('✅ Bluetooth sudah aktif');
      return;
    }

    // Bluetooth masih mati → tampilkan dialog
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Bluetooth Diperlukan'),
        content: const Text(
          'Untuk melanjutkan, nyalakan Bluetooth agar perangkat bisa terhubung.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Nyalakan'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      log('❌ User batal nyalakan Bluetooth');
      return;
    }

    // Cek ulang
    final recheck = await FlutterBluetoothClassic.isBluetoothEnabled();
    if (!recheck) {
      // 👉 Sekarang aman, karena permission CONNECT sudah granted
      final ok = await FlutterBluetoothClassic.enableBluetooth();

      if (ok) {
        bluetoothAdaptor.value = true;
        log('✅ Bluetooth berhasil dinyalakan');
      } else {
        Get.snackbar(
          'Bluetooth Tidak Aktif',
          'Gagal menyalakan Bluetooth. Mohon aktifkan secara manual.',
        );
      }
    } else {
      bluetoothAdaptor.value = true;
      log('✅ Bluetooth sudah aktif (langsung)');
    }
  }

  Future<bool> checkOtaPermission() async {
    final permService = Get.find<PermissionService>();

    bool ok = await permService.hasOtaPermissions();

    if (!ok) {
      ok = await permService.requestOtaPermissions();
    }

    if (!ok) {
      Get.snackbar(
        "Izin Diperlukan",
        "Mohon izinkan akses Storage dan Install Aplikasi untuk melanjutkan update.",
      );

      // Kalau permanently denied
      await openAppSettings();
      return false;
    }

    return true;
  }

  Future<void> requestBluetoothPermission() async {
    final permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.locationWhenInUse, // ✅ penting buat scanning
    ];

    log('Scan: ${await Permission.bluetoothScan.status}');
    log('Connect: ${await Permission.bluetoothConnect.status}');
    log('Advertise: ${await Permission.bluetoothAdvertise.status}');
    log('Location: ${await Permission.locationWhenInUse.status}');

    bool allGranted = true;

    for (var p in permissions) {
      final status = await p.request();
      if (!status.isGranted) {
        allGranted = false;
      }
    }

    bluetoothGranted.value = allGranted;

    if (!allGranted) {
      final permDenied =
          await Future.wait(permissions.map((p) => p.isPermanentlyDenied));
      final isPermanentlyDenied = permDenied.contains(true);

      if (isPermanentlyDenied) {
        Get.snackbar(
          'Izin Diperlukan',
          'Akses Bluetooth diblokir permanen. Aktifkan manual lewat pengaturan aplikasi.',
        );
        await openAppSettings();
      } else {
        Get.snackbar(
          'Izin Diperlukan',
          'Mohon izinkan akses Bluetooth & Lokasi untuk melanjutkan.',
        );
      }
      return;
    }

    // ✅ Tambahan: pastikan GPS aktif
    final serviceEnabled = await Permission.location.serviceStatus.isEnabled;
    if (!serviceEnabled) {
      Get.snackbar(
        'GPS Tidak Aktif',
        'Nyalakan GPS agar perangkat Bluetooth bisa ditemukan.',
      );
      return;
    }

    log('✅ Semua permission & GPS aktif, siap melakukan discovery');
  }

  @override
  Future<void> onInit() async {
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
