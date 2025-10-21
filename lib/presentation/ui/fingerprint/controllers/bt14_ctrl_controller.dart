import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:owl_fp_newer/data/dal/services/get.storage.dart';
import '../../../../core/resources/utils.dart';
import '../../../../core/services/bluetooth.service.dart';

class Bt14CtrlController extends GetxController {
  // States
  RxBool isSupported = false.obs;
  RxBool isEnabled = false.obs;
  RxBool isConnected = false.obs;
  RxBool isDiscovering = false.obs;
  RxBool isConnecting = false.obs;

  var devices = <BluetoothDevice>[].obs;
  BluetoothDevice? selectedDevice;

  // WIFI
  var ssidNm = TextEditingController();
  var ssidPw = TextEditingController();

  // Waktu Upload
  var waktuUploadCtrl = TextEditingController();

  // Client ID
  var clientIDCtrl = TextEditingController();

  // Alamat Server
  var alamatServerCtrl = TextEditingController();

  // Tanggal & Jam
  TimeOfDay tod = TimeOfDay.now();
  DateTime dt = DateTime.now();
  var selectedtod = 'hh:ss'.obs;
  var selectedDt = 'dd/MM/yyyy'.obs;

  // Waktu Delete Absen
  var waktuDeleteCtrl = TextEditingController();

  // Registrasi finger baru
  var selectedRegisterNm = "";
  var selectedRegisterNIK = "";

  // Delete finger karyawan
  var selectedDeleteNm = "";
  var selectedDeleteNIK = "";

  // Otentikasi
  var authCtrl = TextEditingController();
  var authText = '';

  // Buffer untuk data masuk
  StringBuffer buffer = StringBuffer();
  RxBool bufferProcess = false.obs;
  Timer? _idleTimer;
  // final Completer<void> _templateCompleter = Completer<void>();

  // Connection Subscriptions
  StreamSubscription? _stateSub;
  StreamSubscription? _connSub;
  StreamSubscription? _dataSub;
  StreamSubscription? _discoverySub; // 🔹 Tambahan untuk discovery

  // Re-connect
  final handshakeDone = false.obs;

  // Data hasil parse
  RxBool isDone = false.obs;
  final RxInt resultCounter = 0.obs;
  Map<String, dynamic>? deviceInfo;
  List<Map<String, dynamic>> listInsertTemplate = [];
  var box = StorageService.instance;

  @override
  void onInit() {
    super.onInit();
    // _initListeners();
    checkSupport();
    ever(isDone, (registered) {
      if (registered == true && Get.isDialogOpen == true) {
        Get.back(); // nutup dialog
        isDone.value = false; // reset biar ga kepanggil lagi
      }
    });
  }

  @override
  void onClose() {
    _stateSub?.cancel();
    _connSub?.cancel();
    _dataSub?.cancel();
    _discoverySub?.cancel(); // 🔹 cancel discovery saat controller ditutup
    _idleTimer?.cancel();
    super.onClose();
  }

  void _initListeners() {
    // Cancel subscription lama kalau ada
    _stateSub?.cancel();
    _connSub?.cancel();
    _dataSub?.cancel();

    // 🔹 Bluetooth state listener
    _stateSub = FlutterBluetoothClassic.onStateChanged().listen((state) {
      log("📡 Bluetooth state: $state");
      isEnabled.value = (state == "enabled");
    });

    // 🔹 Connection listener
    _connSub = FlutterBluetoothClassic.onConnectionChanged().listen((conn) {
      log("🔌 Connection event: $conn");
      // if (conn.startsWith("connected")) {
      //   isConnected.value = true;
      // } else if (conn.startsWith("disconnected") || conn.startsWith("failed")) {
      //   isConnected.value = false;
      // }
    },);

    // 🔹 Data listener
    _dataSub = FlutterBluetoothClassic.onDataReceived().listen((data) {
      log("📩 Data received: ${data['data']}");
      // Tambahkan ke buffer
      buffer.write(data['data']);
      // Proses buffer
      _processBuffer(
        onComplete: () {
          // Bisa ditambahkan callback jika perlu
        },
      );
    });
  }

  // Fungsi untuk proses buffer JSON
  void _processBuffer({VoidCallback? onComplete}) {
    var foundCompleteJson = false;

    while (true) {
      final current = buffer.toString();
      final endIndex = current.indexOf('}');
      if (endIndex == -1) break;

      final jsonString = current.substring(0, endIndex + 1);

      try {
        final data = json.decode(jsonString);
        log('JSON terdekripsi: $data');

        if (data is Map<String, dynamic>) {
          if (data.containsKey("sn") && data.containsKey("template")) {
            log("Insert To Template $data");
            listInsertTemplate.add(data);
          }

          // jika ada result -> increment resultCounter supaya pengirim bisa
          // mendeteksi balasan segera (tanpa menunggu idle timer)
          if (data.containsKey("result")) {
            log("🔔 Result diterima: ${data['result']}");
            resultCounter.value = resultCounter.value + 1;
          }

          // ✅ Tambahin cek untuk registrasi
          if (data.containsKey("perintah")) {
            log("📌 Perintah dari device: ${data['perintah']}");
            isDone.value = true; // langsung trigger done
          }

          // ✅ Handshake sukses → ada SN
          if (data.containsKey("sn") && data.containsKey("sensor")) {
            log("🤝 Handshake OK dari device SN: ${data['sn']}");
            deviceInfo = data;
            handshakeDone.value = true; // tandain sukses
          }
        }

        foundCompleteJson = true;
      } catch (e) {
        log('Gagal decode JSON: $e');
      } finally {
        buffer.clear();
      }

      final remaining = current.substring(endIndex + 1).trimLeft();
      buffer = StringBuffer(remaining);
    }

    // 🔹 Reset idle timer setiap kali ada JSON valid
    if (foundCompleteJson) {
      _resetIdleTimer(onComplete);
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
    selectedtod.value =
        '${value.hour}:${value.minute}:${now.second.toString().padLeft(2, '0')}';
  }

  void changeDt(DateTime value) {
    final formatter = DateFormat('yyyy-MM-dd');
    selectedDt.value = formatter.format(value);
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

  Future<void> connectDialog() async {
    if (selectedDevice == null) return;

    // Tampilkan dialog loading
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
      log("🔗 Connecting to ${selectedDevice!.address} ...");
      final ok = await FlutterBluetoothClassic.connectInsecure(
        selectedDevice!.address,
      );

      if (ok) {
        isConnected.value = true;
        log("✅ Connected to ${selectedDevice!.name}");

        // Reset handshake flag
        handshakeDone.value = false;

        // Init listener baru setelah connect
        _initListeners();

        // kasih jeda sebentar sebelum handshake
        await Future.delayed(const Duration(milliseconds: 500));

        // kirim handshake
        final sent = await FlutterBluetoothClassic.write("y");
        log("📤 Handshake sent: $sent");

        if (sent) {
          // tunggu response JSON valid (max 5 detik)
          final success = await _waitForHandshake(timeout: 5);
          if (success) {
            log("✅ Handshake berhasil, device siap");
            await saveDeviceInf();
          } else {
            log("⚠️ Handshake timeout, tidak ada balasan dari device");
            Get.snackbar("Error", "Perangkat tidak merespon handshake");
          }
        }
      }
    } catch (e) {
      log("❌ connectDevice error: $e");
      isConnected.value = false;
    }

    // Tutup dialog loading
    if (Get.isDialogOpen == true) Get.back();
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

      // Disconnect dari device
      await FlutterBluetoothClassic.disconnect();
    } catch (e) {
      log("❌ Error saat disconnect: $e");
    } finally {
      // Cancel listener supaya tidak nyangkut
      await _stateSub?.cancel();
      await _connSub?.cancel();
      await _dataSub?.cancel();

      _stateSub = null;
      _connSub = null;
      _dataSub = null;

      // Reset semua flag dan buffer
      isConnected.value = false;
      handshakeDone.value = false;
      isDone.value = false;
      buffer.clear();
      listInsertTemplate.clear();
      resultCounter.value = 0;

      // Cancel timer idle supaya tidak ke-trigger di background
      _idleTimer?.cancel();

      // Kasih delay sebentar supaya socket benar-benar lepas
      await Future.delayed(const Duration(milliseconds: 300));

      log("✅ Device disconnected, listener & state reset");
    }
  }

  Future<void> scanDevices() async {
    await _discoverySub?.cancel(); // cancel dulu biar bisa scan ulang
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

  // Bluetooth Functions Command List
  // 🔹 Fungsi untuk mengirim perintah yang ada pada UI Settings
  Future<void> settings(String auth, int id) async {
    isDone.value = false;
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
          data = "w\n${ssidNm.text}\np\n${ssidPw.text}\n?\n$auth";
          break;
        case 1:
          data = "u\n${waktuUploadCtrl.text}\n?\n$auth";
          break;
        case 2:
          data = "c\ngpsraw";
          break;
        case 3:
          data = "i\n${alamatServerCtrl.text}\n?\n$auth";
          break;
        case 4:
          data = "t\n${selectedDt.value} ${selectedtod.value}\n?\n$auth";
          break;
        case 5:
          data = "1\n${waktuDeleteCtrl.text}\n?\n$auth";
          break;
      }
      // Jalankan proses async
      if (selectedDevice != null && isConnected.value) {
        final ok = await FlutterBluetoothClassic.write(data);
        if (!ok) {
          Get.snackbar("Error", "Gagal mengirim data");
        }
      } else {
        Get.snackbar("Error", "Device belum terhubung");
      }
    } catch (e) {
      // Tampilkan error (jika perlu)
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }
  }

  // 🔹 Fungsi untuk mengabil informasi Device
  Future<void> deviceInf() async {
    try {
      String data = "y"; // Contoh data
      isDone.value = false;

      if (selectedDevice != null && isConnected.value) {
        final ok = await FlutterBluetoothClassic.write(data);
        if (!ok) {
          Get.snackbar("Error", "Gagal mengirim data");
        }
      } else {
        Get.snackbar("Error", "Device belum terhubung");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // Tutup dialog kalau error
    }
  }

  Future<void> saveDeviceInf() async {
    if (isConnected.value && selectedDevice != null) {
      // Kirim data
      await deviceInf();

      // Simpan info device kalau ada
      if (deviceInfo != null) {
        return box.saveFPInfo(deviceInfo!);
      }
    } else {
      Get.snackbar("Error", "Device belum terhubung");
    }
  }

  // 🔹 Fungsi untuk registrasi finger baru / hapus data finger
  Future<void> regdelFinger(int index) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  index == 0 ? 'Registrasi Fingerprint' : 'Delete Fingerprint',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),
                const CircularProgressIndicator(),
                Visibility(visible: index == 0, child: SizedBox(height: 12.h)),
                Visibility(
                  visible: index == 0,
                  child: Text('Silahkan letakan jari anda ke sensor!'),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    });

    try {
      //! Regist
      String regist =
          "r\n$selectedRegisterNIK\n$selectedRegisterNm\n?\n$authText";
      //! Delete
      String delete = "5\n$selectedRegisterNIK\n?\n$authText";
      String data = index == 0 ? regist : delete;

      if (selectedDevice != null && isConnected.value) {
        final ok = await FlutterBluetoothClassic.write(data);
        if (!ok) {
          Get.snackbar("Error", "Gagal mengirim data");
        }
      } else {
        Get.snackbar("Error", "Device belum terhubung");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }

    // 🔹 Tunggu sampai proses selesai (isDone true)
    await waitUntilDone(isDone);

    if (Get.isDialogOpen == true) {
      Get.back();
      resetVariables();
      log(authCtrl.text);
    }
  }

  // 🔹 Fungsi untuk ambil template dari mesin fingerprint
  Future<void> getTemplateFromDevice(String args) async {
    // Tampilkan dialog loading
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
                const Text("Menerima data dari fingerprint!."),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });

    // Listener untuk isDone → close dialog kalau selesai
    once(isDone, (done) {
      if (done == true && Get.isDialogOpen == true) {
        Get.back(); // ✅ Tutup dialog saat parsing udah idle
      }
    });

    try {
      //! String Sent!
      String data = "7\n?\n$args";
      log("Inquiry data: $data");
      isDone.value = false; // reset sebelum mulai

      if (selectedDevice != null && isConnected.value) {
        final ok = await FlutterBluetoothClassic.write(data);
        if (!ok) {
          Get.snackbar("Error", "Gagal mengirim data");
          if (Get.isDialogOpen == true) Get.back();
        }
      } else {
        Get.snackbar("Error", "Device belum terhubung");
        if (Get.isDialogOpen == true) Get.back();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  // 🔹 Fungsi untuk mengirim template ke mesin by NIK
  Future<void> sendTemplByNik(String nik, String template) async {
    const int maxRetry = 3;
    const Duration perAttemptTimeout = Duration(seconds: 10);
    int attempt = 0;
    bool success = false;

    while (attempt < maxRetry && !success) {
      attempt++;
      log("📤 [Attempt $attempt/$maxRetry] Kirim template NIK: $nik");

      final int baseResultCount = resultCounter.value; // baseline

      try {
        final data = "8\n$nik\n$template\n?\n$authText";

        if (selectedDevice == null || !isConnected.value) {
          Get.snackbar("Error", "Device belum terhubung");
          return;
        }

        final ok = await FlutterBluetoothClassic.write(data);
        if (!ok) {
          log("❌ Write failed, akan retry (attempt $attempt)");
          await Future.delayed(
              const Duration(milliseconds: 300)); // sedikit jeda sebelum retry
          continue; // retry
        }

        // tunggu sampai resultCounter berubah (-> device balas) atau timeout
        final start = DateTime.now();
        var gotResponse = false;
        while (DateTime.now().difference(start) < perAttemptTimeout) {
          await Future.delayed(const Duration(milliseconds: 150));
          if (resultCounter.value > baseResultCount) {
            gotResponse = true;
            break;
          }
        }

        if (gotResponse) {
          log("✅ Device merespon untuk NIK $nik (attempt $attempt)");
          success = true;
        } else {
          log("⚠️ Timeout menunggu respon untuk NIK $nik (attempt $attempt)");
          // optional: reconnect logic or small delay before retry
          await Future.delayed(const Duration(milliseconds: 300));
        }
      } catch (e, st) {
        log("❌ Exception saat mengirim NIK $nik: $e\n$st");
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    if (!success) {
      log("🚨 Gagal kirim template untuk NIK: $nik setelah $maxRetry percobaan");
      // opsi: laporkan error, simpan ke queue, dsb.
    }
  }

  // 🔹 Fungsi untuk merubah PIN
  Future<void> gantiPIN(String arg, String auth) async {
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
                CircularProgressIndicator(),
                SizedBox(height: 24.h),
                Text("Mengirimkan perintah!.")
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });
    ever(isDone, (registered) async {
      if (registered == true && Get.isDialogOpen == true) {
        Get.back(); // menutup dialog
        isDone.value = false;
      }
    });
    // String data = "v\n$selectedRegisterNIK\n?\n$auth";
    String data = "x\n$arg\n?\n$auth";
    log("Mengganti PIN: $arg, String: $data");
    try {
      if (selectedDevice != null && isConnected.value) {
        final ok = await FlutterBluetoothClassic.write(data);
        if (!ok) {
          Get.snackbar("Error", "Gagal mengirim data");
        }
      } else {
        Get.snackbar("Error", "Device belum terhubung");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }
  }

  // 🔹 Fungsi untuk menambahkan hak akses admin
  Future<void> addAdminPrivilages(String arg, String auth) async {
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
                CircularProgressIndicator(),
                SizedBox(height: 24.h),
                Text("Mengirimkan perintah!.")
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });
    ever(isDone, (registered) async {
      if (registered == true && Get.isDialogOpen == true) {
        Get.back(); // menutup dialog
        isDone.value = false;
      }
    });
    // String data = "v\n$selectedRegisterNIK\n?\n$auth";
    String data = "v\n$selectedRegisterNIK\n$arg\n?\n$auth";
    log("Nambah Admin dengan NIK: $selectedRegisterNIK, String: $data");
    try {
      if (selectedDevice != null && isConnected.value) {
        final ok = await FlutterBluetoothClassic.write(data);
        if (!ok) {
          Get.snackbar("Error", "Gagal mengirim data");
        }
      } else {
        Get.snackbar("Error", "Device belum terhubung");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (Get.isDialogOpen == true) Get.back(); // ❗️Tutup jika error
    }
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
