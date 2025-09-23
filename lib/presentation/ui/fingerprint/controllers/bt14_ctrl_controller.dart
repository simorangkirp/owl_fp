import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/services/bluetooth.service.dart';

class Bt14CtrlController extends GetxController {
  // States
  RxBool isSupported = false.obs;
  RxBool isEnabled = false.obs;
  RxBool isConnected = false.obs;
  RxBool isDiscovering = false.obs;

  var devices = <BluetoothDevice>[].obs;
  BluetoothDevice? selectedDevice;

  @override
  void onInit() {
    super.onInit();
    _initListeners();
    checkSupport();
  }

  void _initListeners() {
    // 🔹 Bluetooth state listener
    FlutterBluetoothClassic.onStateChanged().listen((state) {
      log("📡 Bluetooth state: $state");
      isEnabled.value = (state == "enabled");
    });

    // 🔹 Connection listener
    FlutterBluetoothClassic.onConnectionChanged().listen((conn) {
      log("🔌 Connection event: $conn");
      if (conn.startsWith("connected")) {
        isConnected.value = true;
      } else if (conn.startsWith("disconnected") || conn.startsWith("failed")) {
        isConnected.value = false;
      }
    });

    // 🔹 Data listener
    FlutterBluetoothClassic.onDataReceived().listen((data) {
      log("📩 Data received: ${data['data']}");
    });
  }

  Future<void> checkSupport() async {
    try {
      isSupported.value = await FlutterBluetoothClassic.isBluetoothSupported();
    } catch (e) {
      log("❌ checkSupport error: $e");
      isSupported.value = false;
    }
  }

  Future<void> checkEnabled() async {
    try {
      isEnabled.value = await FlutterBluetoothClassic.isBluetoothEnabled();
    } catch (e) {
      log("❌ checkEnabled error: $e");
      isEnabled.value = false;
    }
  }

  Future<void> getPairedDevices() async {
    try {
      final list = await FlutterBluetoothClassic.getPairedDevices();
      devices.value = list.map((d) => BluetoothDevice.fromMap(d)).toList();
      for (var d in devices) {
        log("✅ Paired: ${d.name} (${d.address})");
      }
    } catch (e) {
      log("❌ getPairedDevices error: $e");
    }
  }

  Future<void> connectToDevice() async {
    if (selectedDevice == null) return;

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
              const Text("Menghubungkan perangkat..."),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final ok = await FlutterBluetoothClassic.connectInsecure(
          selectedDevice!.address);
      isConnected.value = ok;
    } catch (e) {
      log("❌ connectToDevice error: $e");
      isConnected.value = false;
    }

    if (Get.isDialogOpen == true) Get.back();
  }

  Future<void> disconnectDevice() async {
    try {
      await FlutterBluetoothClassic.disconnect();
      isConnected.value = false;
      selectedDevice = null;
    } catch (e) {
      log("❌ disconnectDevice error: $e");
    }
  }

  Future<void> scanDevices() async {
    devices.clear();
    isDiscovering.value = true;

    try {
      FlutterBluetoothClassic.startDiscovery().listen((device) {
        log("📡 Found: ${device['name']} (${device['address']})");

        final d = BluetoothDevice.fromMap(device);
        if (!devices.any((x) => x.address == d.address)) {
          devices.add(d);
        }
      }, onError: (err) {
        log("❌ scanDevices error: $err");
      }, onDone: () {
        log("✅ Selesai scanning");
        isDiscovering.value = false;
      });
    } catch (e) {
      log("❌ scanDevices exception: $e");
      isDiscovering.value = false;
    }
  }

  Future<void> startDiscoverSequence() async {
    await checkSupport();
    await checkEnabled();
    await scanDevices();
  }
}

/// Helper model
class BluetoothDevice {
  String name;
  String address;

  BluetoothDevice({required this.name, required this.address});

  factory BluetoothDevice.fromMap(Map<dynamic, dynamic> map) {
    return BluetoothDevice(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
