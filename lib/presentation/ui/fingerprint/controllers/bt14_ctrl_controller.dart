import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:owl_fp_newer/core/helper/send.command.ext.dart';
import 'package:owl_fp_newer/core/resources/bt.native.dart';
import 'package:owl_fp_newer/data/dal/services/get.storage.dart';
import 'package:owl_fp_newer/domain/entity/bt.entity.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/connect.device.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/disconnect.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/get.paired.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/init.listener.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/process.parser.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/scan.devices.uc.dart';
import 'package:owl_fp_newer/domain/usecase/bluetooth/send.command.uc.dart';
import 'package:owl_fp_newer/presentation/ui/common/controller/permission.controller.dart';
import '../../../../core/resources/utils.dart';
import '../../../../core/services/bluetooth.service.dart';

class Bt14CtrlController extends GetxController {
  final ScanDevicesUseCase _scanDeviceUc;
  final ConnectDeviceUseCase _connectDeviceUseCase;
  final InitBluetoothListenersUseCase _initBluetoothListenersUseCase;
  final ProcessBluetoothBufferUseCase _processBluetoothBuffer;
  final GetPairedDevicesUseCase _getPairedDevicesUseCase;
  final SendCommandUseCase _sendCommandUseCase;
  final DisconnectDeviceUseCase _disconnectDeviceUseCase;
  Bt14CtrlController(
    this._scanDeviceUc,
    this._connectDeviceUseCase,
    this._initBluetoothListenersUseCase,
    this._processBluetoothBuffer,
    this._getPairedDevicesUseCase,
    this._sendCommandUseCase,
    this._disconnectDeviceUseCase,
  );
  // ─────────────────────────────────────────────────────────────
  // 🧠 STATE VARIABLES
  // ─────────────────────────────────────────────────────────────
  RxBool isSupported = false.obs;
  RxBool isEnabled = false.obs;
  RxBool isConnected = false.obs;
  RxBool isDiscovering = false.obs;
  RxBool isConnecting = false.obs;
  RxBool isIncorrect = false.obs;
  RxBool isDone = false.obs;
  RxBool bufferProcess = false.obs;

  // ─────────────────────────────────────────────────────────────
  // 🔹 BLUETOOTH DEVICE LIST & SELECTION
  // ─────────────────────────────────────────────────────────────
  var devices = <BluetoothDeviceEntity>[].obs;
  final selectedDevice = Rxn<BluetoothDeviceEntity>();
  var bondedDevices = <BluetoothDeviceEntity>[].obs;
  var unBondedDevices = <BluetoothDeviceEntity>[].obs;
  var owlDevices = <BluetoothDeviceEntity>[].obs;

  // ─────────────────────────────────────────────────────────────
  // 🔹 CONTROLLERS (Text Editing)
  // ─────────────────────────────────────────────────────────────
  final ssidNm = TextEditingController();
  final ssidPw = TextEditingController();
  final waktuUploadCtrl = TextEditingController();
  final clientIDCtrl = TextEditingController();
  final alamatServerCtrl = TextEditingController();
  final waktuDeleteCtrl = TextEditingController();
  final authCtrl = TextEditingController();
  final selectedtod = TextEditingController()..text = 'hh:ss';
  final selectedDt = TextEditingController()..text = 'dd/MM/yyyy';
  RxBool isPwObscured = true.obs;

  // ─────────────────────────────────────────────────────────────
  // 🔹 WAKTU
  // ─────────────────────────────────────────────────────────────
  TimeOfDay tod = TimeOfDay.now();
  DateTime dt = DateTime.now();

  // ─────────────────────────────────────────────────────────────
  // 🔹 DATA PARSE BUFFER
  // ─────────────────────────────────────────────────────────────
  StringBuffer buffer = StringBuffer();
  Timer? _idleTimer;
  final RxInt resultCounter = 0.obs;

  // ─────────────────────────────────────────────────────────────
  // 🔹 STREAMS
  // ─────────────────────────────────────────────────────────────
  StreamSubscription? _stateSub;
  StreamSubscription? _connSub;
  StreamSubscription? _dataSub;
  StreamSubscription? _discoverySub;
  StreamSubscription? _btStateSub;

  // ─────────────────────────────────────────────────────────────
  // 🔹 FLAGS
  // ─────────────────────────────────────────────────────────────
  final handshakeDone = false.obs;
  var incorrectString = "";
  Map<String, dynamic>? deviceInfo;
  List<Map<String, dynamic>> listInsertTemplate = [];
  final box = StorageService.instance;

  // ─────────────────────────────────────────────────────────────
  // 🔹 REGISTRASI / DELETE VARIABLES
  // ─────────────────────────────────────────────────────────────
  String selectedRegisterNIK = "";
  String selectedRegisterNm = "";
  String selectedDeleteNIK = "";
  String selectedDeleteNm = "";
  String authText = "";

  @override
  void onInit() {
    super.onInit();
    // _initListeners(); // only after connect
    checkSupport();
    // Start listening to native state stream (EventChannel)
    listenToBluetoothState();

    _initListeners();
    getBondedDevices();

    ever(isDone, (registered) {
      if (registered == true && Get.isDialogOpen == true) {
        Get.back(); // nutup dialog
        isDone.value = false; // reset biar ga kepanggil lagi
      }
    });
  }

  @override
  void onClose() {
    _btStateSub?.cancel();
    _stateSub?.cancel();
    _connSub?.cancel();
    _dataSub?.cancel();
    _discoverySub?.cancel(); // 🔹 cancel discovery saat controller ditutup
    _idleTimer?.cancel();
    super.onClose();
  }

  Future<void> _initListeners() async {
    await _initBluetoothListenersUseCase.execute(
      onStateChanged: (state) {
        isEnabled.value = (state == "enabled");
      },
      onConnectionChanged: (conn) {
        log("🔌 Connection: $conn"); // conn adalah String
      },
      onDataReceived: (data) {
        onDataReceived(data);
      },
    );
  }

  Future<void> _executeWithPermission(
    Future<void> Function() action, {
    bool requireConnectedDevice = true,
  }) async {
    await checkPermission(() async {
      await action();
    }, requireConnectedDevice: requireConnectedDevice);
  }

  void onDataReceived(String dataChunk) {
    buffer.write(dataChunk);
    final result = _processBluetoothBuffer.execute(buffer);

    if (result.insertTemplates.isNotEmpty) {
      listInsertTemplate.addAll(result.insertTemplates);
    }
    if (result.resultCount > 0) {
      resultCounter.value += result.resultCount;
    }
    if (result.done) {
      isDone.value = true;
    }
    if (result.handshakeOk && result.deviceInfo != null) {
      handshakeDone.value = true;
      deviceInfo = result.deviceInfo;
    }
    if (result.incorrect) {
      incorrectString = "incorrect";
      isIncorrect.value = true;
      isDone.value = true;
    }

    if (result.hasValidJson) {
      _resetIdleTimer(() {
        // misalnya callback setelah parsing selesai
        log("✅ Idle timer di-reset karena JSON valid diterima");
      });
    }
  }

  /// Listen ke EventChannel dari native (BluetoothService.bluetoothStateStream)
  void listenToBluetoothState() {
    _btStateSub?.cancel();
    try {
      _btStateSub = BluetoothService.bluetoothStateStream.listen((state) {
        log("📡 Bluetooth state (native): $state");

        final s = state.toLowerCase();
        final enabled = s.contains("on") || s == "enabled";

        // update reactive
        final prev = isEnabled.value;
        isEnabled.value = enabled;

        // jika perubahan: lakukan tindakan
        if (prev != enabled) {
          if (!enabled) {
            // Bluetooth dimatikan
            isConnected.value = false;
            selectedDevice.value = null; // 🔄 reset device
            // Cancel connection/data listeners jika ada
            _connSub?.cancel();
            _dataSub?.cancel();

            // Tutup dialog jika ada
            if (Get.isDialogOpen == true) {
              Get.back();
            }
            log("📡 Bluetooth state changed: $enabled (prev: $prev)");
            // Tampilkan snackbar / info
            showSnackBar(
                'Bluetooth telah nonaktif. Aktifkan kembali untuk melanjutkan.');
          } else {
            // Bluetooth diaktifkan
            showSnackBar('Bluetooth telah diaktifkan.');
          }
        }
      }, onError: (err) {
        log("❌ listenToBluetoothState error: $err");
      });
    } catch (e) {
      log("❌ listenToBluetoothState exception: $e");
    }
  }

  void _resetIdleTimer(VoidCallback? onComplete) {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 12), () {
      log("⏱ Idle timeout tercapai → parsing dianggap selesai");
      isDone.value = true; // ✅ langsung trigger flag done
      onComplete?.call();
    });
  }

  /// Syncronous Funtion List
  void changeTod(TimeOfDay value) {
    final now = DateTime.now();
    selectedtod.text =
        '${value.hour}:${value.minute}:${now.second.toString().padLeft(2, '0')}';
  }

  void changeDt(DateTime value) {
    final formatter = DateFormat('yyyy-MM-dd');
    selectedDt.text = formatter.format(value);
    // selectedDt.value = '${value.day}/${value.month}/${value.year}';
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
    log("⚙️ checkEnabled() mulai dipanggil");
    try {
      final enabled = await FlutterBluetoothClassic.isBluetoothEnabled();
      log("📡 Hasil native: $enabled");
      isEnabled.value = enabled;
      log("✅ isEnabled.value di-set: ${isEnabled.value}");
    } catch (e) {
      log("❌ checkEnabled error: $e");
      isEnabled.value = false;
    }
  }

  Future<void> getPairedDevices() async {
    try {
      final list = await _getPairedDevicesUseCase();
      devices.value = list;
      for (var d in list) {
        log("✅ Paired: ${d.name} (${d.address})");
      }
    } catch (e) {
      log("❌ getPairedDevices error: $e");
    }
  }

  Future<void> connectDialog() async {
    if (selectedDevice.value == null) return;

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
      await _connectDeviceUseCase.execute(selectedDevice.value!);
      isConnected.value = true;
      handshakeDone.value = true;
    } catch (e) {
      isConnected.value = false;
      Get.snackbar("Error", e.toString());
      log("❌ connectDialog error: $e");
    } finally {
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  /// 🔹 Fungsi untuk ambil semua data dari device
  Future<void> fetchDeviceData() async {
    if (!isConnected.value) {
      Get.snackbar("Error", "Device belum terhubung");
      return;
    }

    log("📡 Mengambil data dari device...");

    try {
      // Kirim beberapa perintah berurutan
      await _sendDeviceCommand("y", desc: "Device Info");
      await Future.delayed(const Duration(milliseconds: 300));
      if (deviceInfo != null) {
        await box.saveFPInfo(deviceInfo!);
      }
      await _sendDeviceCommand("9", desc: "WiFi Info");
      await Future.delayed(const Duration(milliseconds: 300));

      await _sendDeviceCommand("I", desc: "URI Info");

      log("✅ Semua data device berhasil diminta");
    } catch (e) {
      log("❌ fetchDeviceData error: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  // 🔹 Fungsi untuk mengabil informasi Device
  Future<void> _sendDeviceCommand(String command, {String? desc}) async {
    try {
      log("📤 Mengirim perintah ${desc ?? command} ($command)...");

      // 🔹 Kirim perintah ke device
      await _executeWithPermission(() async {
        await _sendCommandUseCase.call(
          data: command,
          desc: desc,
        );
      });

      // 🔹 Tunggu respons handshake dari device
      final success = await _waitForHandshake(timeout: 5);

      if (success) {
        log("✅ Respons diterima untuk ${desc ?? command}");
      } else {
        log("⚠️ Timeout menunggu respons ${desc ?? command}");
      }
    } catch (e) {
      log("❌ _sendDeviceCommand error: $e");
      rethrow;
    }
  }

  // Fungsi tunggu handshake selesai
  Future<bool> _waitForHandshake({int timeout = 5}) async {
    int elapsed = 0;
    while (elapsed < timeout) {
      if (handshakeDone.value) return true;
      await Future.delayed(const Duration(seconds: 1));
      elapsed++;
    }
    return false;
  }

  Future<void> disconnectDevice() async {
    try {
      log("🔌 Disconnecting from device...");
      await _disconnectDeviceUseCase(); // pakai usecase
    } catch (e) {
      log("❌ Error saat disconnect: $e");
    } finally {
      await _stateSub?.cancel();
      await _connSub?.cancel();
      await _dataSub?.cancel();

      _stateSub = null;
      _connSub = null;
      _dataSub = null;

      isConnected.value = false;
      handshakeDone.value = false;
      isDone.value = false;
      buffer.clear();
      listInsertTemplate.clear();
      resultCounter.value = 0;

      _idleTimer?.cancel();

      await Future.delayed(const Duration(milliseconds: 300));

      log("✅ Device disconnected, listener & state reset");
    }
  }

  //
  Future<void> scanDevices() async {
    await _scanDeviceUc.checkPermission(() async {
      log('🚀 scanDevices (clean version)');
      await _scanDeviceUc.cancel(); // cancel scan sebelumnya

      // Bersihkan semua list agar hasil fresh
      devices.clear();
      bondedDevices.clear();
      unBondedDevices.clear();
      owlDevices.clear();

      isDiscovering.value = true;

      try {
        // Ambil paired devices (bonded list dari sistem)
        final pairedList = await FlutterBluetoothClassic.getPairedDevices();
        log("📡 Paired devices ditemukan: ${pairedList.length}");

        _discoverySub = _scanDeviceUc.execute().listen((device) {
          log("📍 Found: ${device.name} (${device.address})");

          // 🔍 Cegah duplikat di semua list
          bool alreadyExists(String addr) =>
              devices.any((x) => x.address == addr) ||
              bondedDevices.any((x) => x.address == addr) ||
              unBondedDevices.any((x) => x.address == addr) ||
              owlDevices.any((x) => x.address == addr);

          if (alreadyExists(device.address)) return;

          // Tambahkan ke list utama
          devices.add(device);

          // 🔎 Cek apakah termasuk paired / OWL
          final isPaired = pairedList.any(
            (p) => p['address']?.toString() == device.address.toString(),
          );

          final isOwl = device.name.toUpperCase().contains("OWL") ||
              device.address.toUpperCase().contains("OWL");

          // Buat entitas device baru
          final newEntity = BluetoothDeviceEntity(
            name: device.name,
            address: device.address,
            bonded: isPaired,
          );

          // 💡 Klasifikasi sesuai kategori
          if (isOwl) {
            owlDevices.add(newEntity);
          }
          if (isPaired) {
            bondedDevices.add(newEntity);
          } else {
            unBondedDevices.add(newEntity);
          }
        }, onError: (err) {
          log("❌ scanDevices error: $err");
        }, onDone: () {
          log("✅ Selesai scanning");
          log("📊 bonded: ${bondedDevices.length}, unbonded: ${unBondedDevices.length}, owl: ${owlDevices.length}");
          isDiscovering.value = false;
        });
      } catch (e) {
        log("❌ scanDevices exception: $e");
        isDiscovering.value = false;
      }
    });
  }

  Future<void> startDiscoverSequence() async {
    await checkSupport();

    if (!isSupported.value) {
      showSnackBar("Perangkat ini tidak mendukung Bluetooth.");
      return;
    }

    await checkEnabled();

    // 🔹 Kalau belum aktif, minta user nyalakan dulu
    if (!isEnabled.value) {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Bluetooth mati"),
          content: const Text(
              "Aktifkan Bluetooth untuk melanjutkan pemindaian perangkat."),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text("Aktifkan"),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final ok = await FlutterBluetoothClassic.enableBluetooth();
        if (!ok) {
          showSnackBar("Bluetooth gagal diaktifkan, coba secara manual.");
          return;
        }

        // Tunggu sedikit biar sistem update status
        await Future.delayed(const Duration(seconds: 2));
        await checkEnabled();
        if (!isEnabled.value) {
          showSnackBar("Bluetooth masih belum aktif.");
          return;
        }
      } else {
        showSnackBar("Bluetooth belum diaktifkan.");
        return;
      }
    }

    // 🚀 Bluetooth aktif, lanjut ke scanning
    await scanDevices();
  }

  // Bluetooth Functions Command List
  // 🔹 Fungsi untuk mengirim perintah yang ada pada UI Settings
  Future<void> settings(String auth, int id) async {
    if (selectedDevice.value == null || !isConnected.value) {
      Get.snackbar("Error", "Device belum terhubung");
      return;
    }

    final data = switch (id) {
      0 => "w\n${ssidNm.text}\np\n${ssidPw.text}\n?\n$auth",
      1 => "u\n${waktuUploadCtrl.text}\n?\n$auth",
      2 => "c\ngpsraw",
      3 => "i\n${alamatServerCtrl.text}\n?\n$auth",
      4 => "t\n${selectedDt.text} ${selectedtod.text}\n?\n$auth",
      5 => "1\n${waktuDeleteCtrl.text}\n?\n$auth",
      _ => "",
    };
    await _executeWithPermission(() async {
      await _sendCommandUseCase.callWithUI(
        data: data,
        desc: "Setting Command",
        doneFlag: isDone,
      );
    });
  }

  // 🔹 Fungsi untuk registrasi finger baru / hapus data finger
  // Registrasi / Delete Finger
  Future<void> regDelFinger({
    required bool isRegister,
    required String nik,
    required String name,
    required String auth,
  }) async {
    final data = isRegister ? "r\n$nik\n$name\n?\n$auth" : "5\n$nik\n?\n$auth";
    await _executeWithPermission(() async {
      await _sendCommandUseCase.callWithUI(
        data: data,
        desc: isRegister ? "Registrasi Fingerprint" : "Hapus Fingerprint",
        doneFlag: isDone,
      );
    });
  }

  // 🔹 Fungsi untuk ambil template dari mesin fingerprint
  Future<void> getTemplateFromDevice(String args) async {
    await _executeWithPermission(() async {
      await _sendCommandUseCase.callWithUI(
        data: "7\n?\n$args",
        desc: "Ambil Template",
        doneFlag: isDone,
      );
    });
  }

  // 🔹 Fungsi untuk mengirim template ke mesin by NIK
  Future<void> sendTemplateByNIK(
      String nik, String template, String auth) async {
    await _executeWithPermission(() async {
      await _sendCommandUseCase.callWithUI(
        data: "8\n$nik\n$template\n?\n$auth",
        desc: "Kirim Template $nik",
        resultCounter: resultCounter,
        useRetry: true,
        maxRetry: 3,
        successMsg: "Template untuk $nik berhasil dikirim",
      );
    });
  }

  // 🔹 Fungsi untuk merubah PIN
  Future<void> gantiPIN(String newPin, String auth) async {
    await _executeWithPermission(() async {
      await _sendCommandUseCase.callWithUI(
        data: "x\n$newPin\n?\n$auth",
        desc: "Ganti PIN",
        doneFlag: isDone,
      );
    });
  }

  // 🔹 Fungsi untuk menambahkan hak akses admin
  Future<void> addAdminPrivileges(String arg, String auth, String nik) async {
    await _executeWithPermission(() async {
      await _sendCommandUseCase.callWithUI(
        data: "v\n$nik\n$arg\n?\n$auth",
        desc: "Tambah Admin",
        doneFlag: isDone,
      );
    });
  }

  // Reset All Variables
  Future<void> resetVariables() async {
    ssidNm.clear();
    ssidPw.clear();
    waktuUploadCtrl.clear();
    clientIDCtrl.clear();
    alamatServerCtrl.clear();
    waktuDeleteCtrl.clear();
    authCtrl.clear();
    selectedRegisterNm = "";
    selectedRegisterNIK = "";
    selectedDeleteNm = "";
    selectedDeleteNIK = "";
    isDone.value = false;
    listInsertTemplate.clear();
    bufferProcess.value = false;
  }

  // 🔹 Fungsi untuk merubah PIN
  Future<void> resetFactory() async {
    if (selectedDevice.value == null || !isConnected.value) {
      Get.snackbar("Error", "Device belum terhubung");
      return;
    }
    await _executeWithPermission(() async {
      await _sendCommandUseCase.callWithUI(
        data: "n\n?\n$authText",
        desc: "Reset Factory",
        doneFlag: isDone,
      );
    });
  }

  Future<void> checkPermission(
    Function onGranted, {
    bool requireConnectedDevice = true,
  }) async {
    final permCtrl = Get.find<PermissionController>();

    log("Selected: ${selectedDevice.value}, IsCon: ${isConnected.value}, ReqCon: $requireConnectedDevice");
    await permCtrl.checkBtAdaptor();
    if (!permCtrl.bluetoothAdaptor.value) {
      showSnackBar("Adaptor Bluetooth tidak ditemukan atau belum aktif.");
      return;
    }

    await permCtrl.requestBluetoothPermission();
    if (!permCtrl.bluetoothGranted.value) {
      showSnackBar("Mohon izinkan akses Bluetooth terlebih dahulu.");
      return;
    }

    // 🔥 Cek koneksi hanya kalau dibutuhkan
    if (requireConnectedDevice) {
      if (selectedDevice.value == null || !isConnected.value) {
        showSnackBar("Belum ada perangkat Bluetooth yang terhubung.");
        return;
      }
    }

    await onGranted();
  }

  Future<void> getBondedDevices() async {
    try {
      final pairedList = await FlutterBluetoothClassic.getPairedDevices();

      // 🔄 Konversi hasil native (Map) ke entity
      final entities =
          pairedList.map((map) => BluetoothDeviceEntity.fromMap(map)).toList();

      bondedDevices.value = entities;

      // 🔍 Filter device yang mengandung kata "OWL" (case-insensitive)
      final filtered =
          entities.where((d) => d.name.toUpperCase().contains('OWL')).toList();

      owlDevices.value = filtered;

      log('✅ Paired devices ditemukan: ${entities.length}');
      log('🦉 Ditemukan OWL devices: ${filtered.map((d) => d.name).toList()}');
    } catch (e) {
      log('❌ Gagal mengambil paired devices: $e');
      bondedDevices.clear();
      owlDevices.clear();
    }
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
