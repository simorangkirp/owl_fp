import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  var devices = <BluetoothDevice>[].obs;
  var connectedDevice = Rxn<BluetoothDevice>();
  BluetoothConnection? connection;
  // var discoveredDevices = <BluetoothDiscoveryResult>[].obs;
  var isDiscovering = false.obs;
  var deviceFound = 0.obs;
  bool? isEnabled;
  StreamSubscription<BluetoothDiscoveryResult>? discoveryStream;
  final RxList<BluetoothDiscoveryResult> discoveredDevices =
      <BluetoothDiscoveryResult>[].obs;
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStream;
  var connectionStates = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getBondedDevices();
  }

  @override
  void onClose() {
    _discoveryStream?.cancel();
    super.onClose();
  }

  Future<void> btStats() async {
    var isEna = await FlutterBluetoothSerial.instance.isEnabled;
    if (isEna != null) {
      if (isEna) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.dialog(
            Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 20),
                    Obx(() => Text(
                        "Menemukan ${deviceFound.value.toString()} perangkat.")),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );
        });
        try {
          deviceFound.value = 0;
          // Jalankan proses async
          Future.delayed(const Duration(milliseconds: 500));
          await startDiscovery();

          // Tutup dialog saat proses selesai
          // if (Get.isDialogOpen == true) {
          //   Get.back();
          // }
        } finally {
          if (Get.isDialogOpen == true) Get.back();
        }
        // catch (e) {
        //   // Tutup dialog kalau error
        //   if (Get.isDialogOpen == true) Get.back();

        //   // Tampilkan pesan error
        //   Get.snackbar("Error", e.toString());
        // }
      } else {
        await FlutterBluetoothSerial.instance.requestEnable();
      }
    }
  }

  Future<void> startDiscovery() async {
    // Cancel discovery lama kalau masih ada
    await _discoveryStream?.cancel();
    isDiscovering.value = true;
    discoveredDevices.clear();
    _discoveryStream =
        FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      deviceFound.value++;
      discoveredDevices.add(result);
    }, onDone: () {
      stopDiscovery();
      isDiscovering.value = false;
    });
  }

  void stopDiscovery() {
    if (Get.isDialogOpen == true) Get.back();
    try {
      _discoveryStream?.cancel();
      _discoveryStream = null;
    } catch (e) {
      log("Stop discovery error: $e");
    }
  }

  void getBondedDevices() async {
    List<BluetoothDevice> bonded =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    devices.value = bonded;
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      connectedDevice.value = device;
      // Connect ke device...
      connectionStates[device.address] = true;

      connection!.input!.listen((data) {
        Get.snackbar(
          '',
          "Berhasil Terhubung!",
          titleText: const SizedBox.shrink(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 2), // Supaya tidak hilang otomatis
          margin: const EdgeInsets.all(12),
        );
        log('Received: ${String.fromCharCodes(data)}');
      });
    } catch (e) {
      Get.snackbar('Error', 'Gagal konek: $e');
    }
  }

  void send(String data) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList(data.codeUnits));
      connection!.output.allSent;
    }
  }

  void disconnect() {
    connectionStates[connectedDevice.value!.address] = false;
    connection?.dispose();
    connectedDevice.value = null;
  }
}
