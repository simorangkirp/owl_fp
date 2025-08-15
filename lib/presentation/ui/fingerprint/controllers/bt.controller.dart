import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owl_fp/presentation/ui/fingerprint/controllers/fingerprint.controller.dart';

import '../../../../data/dal/services/get.storage.dart';

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
  var listReply = <String>[];

  Map<String, dynamic>? deviceInfo;

  var buffer = StringBuffer();
  Timer? _debounceTimer;

  /// WIFI
  var ssid = TextEditingController();
  var wPwd = TextEditingController();

  /// Waktu Upload
  var wUpload = TextEditingController();

  /// Client Secret
  var csTCtrl = TextEditingController();

  /// Waktu Delete
  var wdTCtrl = TextEditingController();

  /// Alamat Server
  var uriTCtrl = TextEditingController();

  /// Authentication
  var authCtrl = TextEditingController();
  var authText = '';

  ///

  /// Register Finger
  var selectedRegisterNm = "";
  var selectedRegisterNIK = "";
  RxBool isDone = false.obs;
  RxBool btPaired = false.obs;

  ///

  /// Upload Download Template Finger
  List<Map<String, dynamic>> listInsertTemplate = [];

  ///

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

  Future<void> connectDialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Menghubungkan Perangkat',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),
                const CircularProgressIndicator(),
                SizedBox(height: 12.h),
                Text('Sedang menghubungkan ke perangkat.')
                // Text("Menemukan ${deviceFound.value.toString()} perangkat.")
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    });
    // Pantau kondisi isRegistered dan tutup dialog jika true
    ever(btPaired, (registered) async {
      await saveDeviceInf();
      if (registered == true && Get.isDialogOpen == true) {
        Get.back(); // menutup dialog
      }
    });
  }

  Future<void> saveDeviceInf() async {
    if (connection!.isConnected) {
      await deviceInf();
      if (deviceInfo != null) {
        var box = StorageService();
        box.saveFPInfo(deviceInfo!);
      }
    }
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
        } finally {
          if (Get.isDialogOpen == true) Get.back();
        }
      } else {
        await FlutterBluetoothSerial.instance.requestEnable();
      }
    }
  }

  Future<void> waitRegist() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Registrasi Finger',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),
                const CircularProgressIndicator(),
                SizedBox(height: 12.h),
                Text('Silahkan letakan jari anda ke sensor!')
                // Text("Menemukan ${deviceFound.value.toString()} perangkat.")
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    });
    // Pantau kondisi isRegistered dan tutup dialog jika true
    ever(isDone, (registered) {
      if (registered == true && Get.isDialogOpen == true) {
        Get.back(); // menutup dialog
      }
    });
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
      btPaired.value = true;
      connection!.input!.listen((data) {
        final chunk = String.fromCharCodes(data);
        log('chunk: $chunk');

        buffer.write(chunk);
        log('buffer: $buffer');
        // Reset timer tunggu
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
          _processBuffer();
        });
      });
    } catch (e) {
      Get.snackbar('Error', 'Gagal konek: $e');
    }
  }

  void cekbouncer() {
    if (_debounceTimer?.isActive ?? false) {
      log("Timer masih jalan");
      isDone.value = false;
    } else {
      log("Timer sudah selesai atau dibatalkan");
      //! BARU JALANIN INSERTNYA
      if (listInsertTemplate.isNotEmpty) {
        final fpC = Get.find<FingerprintController>();
        fpC.dataTemplate = listInsertTemplate;
      }
      isDone.value = true;
    }
  }

  void _processBuffer() {
    while (true) {
      final current = buffer.toString();
      final endIndex = current.indexOf('}');

      if (endIndex == -1) break; // belum ada penutup JSON

      final jsonString = current.substring(0, endIndex + 1);

      try {
        final data = json.decode(jsonString);
        log('JSON terdekripsi: $data');
        if (data is Map<String, dynamic>) {
          if (data.containsKey("perintah")) {
            isDone.value = true;
          }
          if (data.containsKey("sn") && data.containsKey("name")) {
            deviceInfo = data;
          }
          if (data.containsKey("sn") && data.containsKey("template")) {
            listInsertTemplate.add(data);
          }
        }
      } catch (e) {
        log('Gagal decode JSON: $e');
      } finally {
        buffer.clear(); // siap terima data baru
      }

      // Buat buffer baru, hapus bagian yang udah diproses
      final remaining = current.substring(endIndex + 1).trimLeft();
      buffer = StringBuffer(remaining);
    }
  }

  Future<void> sendRegist() async {
    try {
      //! Regist
      String data =
          "r\n$selectedRegisterNIK\n$selectedRegisterNIK\n?\n$authText";
      //! Delete
      isDone.value = false;
      if (connection != null && connection!.isConnected) {
        connection!.output.add(Uint8List.fromList(data.codeUnits));
        await connection!.output.allSent;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }
  }

  Future<void> deviceInf() async {
    try {
      //! String Sent!
      // String data = "r\n8\nPPPPPPE16010047\nMachfud Djunaedi\ntemplate\n?\n$authText";
      String data = "y";
      isDone.value = false;
      if (connection != null && connection!.isConnected) {
        connection!.output.add(Uint8List.fromList(data.codeUnits));
        await connection!.output.allSent;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }
  }

  Future<void> devSend(String args) async {
    try {
      //! String Sent!
      // String data = "r\n8\nPPPPPPE16010047\nMachfud Djunaedi\ntemplate\n?\n$authText";
      String data = "7\n?\n$args";
      // log(data);
      // String data = "y";
      isDone.value = false;
      if (connection != null && connection!.isConnected) {
        connection!.output.add(Uint8List.fromList(data.codeUnits));
        await connection!.output.allSent;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }
  }

  Future<void> send(String args, int id) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Dialog(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.2.sh),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 24.h),
                  Text("Mengirimkan perintah!.")
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });
    try {
      String data = "";
      switch (id) {
        case 0:
          data = "w\n${ssid.text}\np\n${wPwd.text}\n?\n$args";
          break;
        case 1:
          data = "u\n${wUpload.text}\n?\n$args";
          break;
        case 2:
          data = "c\ngpsraw";
          break;
        case 3:
          data = "i\n${uriTCtrl.text}\n?\n$args";
          break;
        case 4:
          break;
        case 5:
          data = "1\n${wdTCtrl.text}\n?\n$args";
          break;
      }
      // Jalankan proses async
      if (connection != null && connection!.isConnected) {
        connection!.output.add(Uint8List.fromList(data.codeUnits));
        await connection!.output.allSent;

        await Future.delayed(const Duration(seconds: 3)).then((value) {
          // ❗️Dialog hanya ditutup setelah pengiriman sukses (jika kamu mau)
          Get.back();
          if (listReply.isNotEmpty) {
            displayReply();
          }
        });
      }
    } catch (e) {
      // Tampilkan error (jika perlu)
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }
  }

  void displayReply() {
    Get.snackbar(
      '',
      listReply[1],
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2), // Supaya tidak hilang otomatis
      margin: const EdgeInsets.all(12),
    );
    listReply.clear();
  }

  void disconnect() {
    connectionStates[connectedDevice.value!.address] = false;
    connection?.dispose();
    connectedDevice.value = null;
  }
}
