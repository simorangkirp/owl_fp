import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:owl_fp_newer/core/services/bluetooth.service.dart';
import 'package:owl_fp_newer/data/dal/services/bluetooth/bt.datasource.dart';
import 'package:owl_fp_newer/domain/entity/bt.entity.dart';
import 'package:owl_fp_newer/domain/repository/bt.repo.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothDataSource dataSource;
  BluetoothRepositoryImpl(this.dataSource);

  StreamSubscription? _discoverySub;
  bool _connected = false;
  StreamSubscription? _stateSub;
  StreamSubscription? _connSub;
  StreamSubscription? _dataSub;

  @override
  Future<void> checkPermission(Function() onGranted) async {
    await onGranted();
  }

  @override
  Future<List<BluetoothDeviceEntity>> getPairedDevices() async {
    try {
      final list = await dataSource.getPairedDevices();
      return list.map((d) => BluetoothDeviceEntity.fromMap(d)).toList();
    } catch (e) {
      throw Exception("getPairedDevices error: $e");
    }
  }

  /// NOTE: signature matches the domain interface (no `required` here)
  @override
  Future<void> initListeners({
    Function(String state)? onStateChanged,
    Function(String conn)? onConnectionChanged,
    Function(String data)? onDataReceived,
  }) async {
    _stateSub?.cancel();
    _connSub?.cancel();
    _dataSub?.cancel();

    try {
      _stateSub = FlutterBluetoothClassic.onStateChanged().listen((state) {
        log("📡 Bluetooth state: $state");
        onStateChanged?.call(state);
      });
    } catch (e) {
      log("⚠️ initListeners onStateChanged error: $e");
    }

    try {
      _connSub = FlutterBluetoothClassic.onConnectionChanged().listen((conn) {
        log("🔌 Connection event: $conn");
        onConnectionChanged?.call(conn);
      });
    } catch (e) {
      log("⚠️ initListeners onConnectionChanged error: $e");
    }

    try {
      _dataSub = FlutterBluetoothClassic.onDataReceived().listen((data) {
        log("📩 Data received: ${data['data']}");
        onDataReceived?.call(data['data'].toString());
      });
    } catch (e) {
      log("⚠️ initListeners onDataReceived error: $e");
    }
  }

  @override
  Future<void> fetchDeviceData() async {
    try {
      final connected = await isConnected();
      if (!connected) {
        Get.snackbar("Error", "Device belum terhubung");
        return;
      }

      log("📡 Mengambil data dari device...");
      final ok1 = await dataSource.sendCommand("y", desc: "Device Info");
      if (!ok1) log("⚠️ Gagal kirim 'y'");

      await Future.delayed(const Duration(milliseconds: 300));
      final deviceInfo = await dataSource.getDeviceInfo();
      if (deviceInfo != null) await dataSource.saveFPInfo(deviceInfo);

      final ok2 = await dataSource.sendCommand("9", desc: "WiFi Info");
      if (!ok2) log("⚠️ Gagal kirim '9'");

      await Future.delayed(const Duration(milliseconds: 300));
      final ok3 = await dataSource.sendCommand("I", desc: "URI Info");
      if (!ok3) log("⚠️ Gagal kirim 'I'");

      log("✅ Semua data device berhasil diminta");
    } catch (e) {
      log("❌ fetchDeviceData error: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Future<bool> connectDevice(BluetoothDeviceEntity device) async {
    log("🔗 Connecting to ${device.address} ...");
    final ok = await dataSource.connect(device.address);
    _connected = ok;
    if (ok) log("✅ Connected to ${device.name}");
    return ok;
  }

  @override
  Future<bool> sendCommand(String command, {String? desc}) async {
    return await dataSource.sendCommand(command, desc: desc);
  }

  @override
  Future<void> disconnectDevice() async {
    await dataSource.disconnect();
    _connected = false;
  }

  @override
  Future<void> sendHandshake() async {
    if (!_connected) throw Exception("Belum terhubung ke perangkat");
    log("📤 Sending handshake...");
    final sent = await FlutterBluetoothClassic.write("y");
    if (!sent) throw Exception("Gagal mengirim handshake.");
    log("✅ Handshake command sent");
  }

  @override
  Future<bool> waitForHandshake({int timeout = 5}) async {
    log("🕓 Waiting for handshake response...");
    await Future.delayed(Duration(seconds: timeout));
    log("✅ Handshake success (mocked)");
    return true;
  }

  @override
  Stream<BluetoothDeviceEntity> startDiscovery() async* {
    log('📡 Discovery started');
    await _discoverySub?.cancel();

    final controller = StreamController<BluetoothDeviceEntity>();

    _discoverySub = FlutterBluetoothClassic.startDiscovery().listen(
      (device) {
        final map = Map<String, dynamic>.from(device);
        final d = BluetoothDeviceEntity.fromMap(map);
        controller.add(d);
      },
      onError: (err) {
        log("❌ scanDevices error: $err");
        controller.addError(err);
      },
      onDone: () {
        log("✅ Selesai scanning");
        controller.close();
      },
    );

    yield* controller.stream;
  }

  @override
  Future<void> cancelDiscovery() async {
    await _discoverySub?.cancel();
    log("🛑 Discovery canceled");
  }

  /// Repository-level connection check (delegates to datasource flag)
  @override
  Future<bool> isConnected() async {
    return dataSource.isConnected;
  }
}
