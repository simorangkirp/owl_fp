import 'dart:developer';
import 'package:owl_fp_newer/core/services/bluetooth.service.dart';

class BluetoothDataSource {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<bool> isBluetoothSupported() async =>
      await FlutterBluetoothClassic.isBluetoothSupported();

  /// Koneksi ke device — set _isConnected sesuai hasil
  Future<bool> connect(String address) async {
    try {
      final result = await FlutterBluetoothClassic.connectInsecure(address);
      _isConnected = result == true;
      log("✅ Connected to $address -> $_isConnected");
      return _isConnected;
    } catch (e) {
      _isConnected = false;
      log("❌ Gagal connect: $e");
      rethrow;
    }
  }

  /// Putuskan koneksi dan reset flag
  Future<void> disconnect() async {
    try {
      await FlutterBluetoothClassic.disconnect();
      _isConnected = false;
      log("🔌 Disconnected successfully");
    } catch (e) {
      log("❌ Error disconnect: $e");
      rethrow;
    }
  }

  /// Kirim perintah ke device, return true kalau berhasil
  Future<bool> sendCommand(String command, {String? desc}) async {
    log("📤 Sending command: $command (${desc ?? 'no desc'})");
    try {
      final sent = await FlutterBluetoothClassic.write(command);
      if (sent == true) {
        return true;
      } else {
        log("❌ write returned false for command: $command");
        return false;
      }
    } catch (e) {
      log("❌ sendCommand error: $e");
      rethrow;
    }
  }

  /// Dummy ambil informasi perangkat (implement sendiri sesuai format device)
  Future<Map<String, dynamic>?> getDeviceInfo() async {
    log("📥 getDeviceInfo belum diimplementasi");
    return null;
  }

  Future<void> saveFPInfo(Map<String, dynamic> info) async {
    log("💾 Simpan info device: $info");
  }

  /// Ambil daftar paired devices (raw map)
  Future<List<Map<String, dynamic>>> getPairedDevices() async {
    final list = await FlutterBluetoothClassic.getPairedDevices();
    return List<Map<String, dynamic>>.from(list);
  }

  /// Simpel: asynchronous getter status koneksi (mengembalikan flag internal)
  Future<bool> getConnectionStatus() async {
    return _isConnected;
  }
}
