import 'dart:developer';

import 'package:get/get.dart';
import 'package:owl_fp_newer/domain/entity/bt.entity.dart';
import 'package:owl_fp_newer/domain/repository/bt.repo.dart';
import 'package:owl_fp_newer/presentation/ui/common/controller/permission.controller.dart';

class ScanDevicesUseCase {
  final BluetoothRepository repository;

  ScanDevicesUseCase(this.repository);

  /// Mulai scanning, return STREAM
  Stream<BluetoothDeviceEntity> execute() {
    return repository.startDiscovery();
  }

  /// Stop scanning
  Future<void> cancel() async {
    await repository.cancelDiscovery();
  }

  /// Cek permission + adaptor + jalankan callback
  Future<void> checkPermission(
    Future<void> Function() onGranted,
  ) async {
    final permCtrl = Get.find<PermissionController>();

    // 1️⃣ Cek adaptor Bluetooth aktif
    await permCtrl.checkBtAdaptor();
    if (!permCtrl.bluetoothAdaptor.value) {
      return; // ❌ adaptor mati → stop
    }

    // 2️⃣ Minta permission BLUETOOTH_CONNECT
    await permCtrl.requestBluetoothPermission();
    if (!permCtrl.bluetoothGranted.value) {
      return; // ❌ ditolak → stop
    }

    // 3️⃣ Jalankan action
    try {
      await onGranted();
    } catch (e) {
      // biar ga crash kalau callback error
      log("❌ ScanDevicesUseCase.onGranted error: $e");
    }
  }
}
