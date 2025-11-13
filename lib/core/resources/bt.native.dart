import 'dart:developer';
import 'package:flutter/services.dart';

class BluetoothService {
  /// MethodChannel utama untuk komunikasi satu arah (invoke → native)
  static const _methodChannel =
      MethodChannel('flutter_bluetooth_classic/methods');

  /// EventChannel untuk menerima perubahan status Bluetooth dari native
  static const _stateChannel =
      EventChannel('flutter_bluetooth_classic/state');

  // ---------------------------------------------------------------------------
  // 🔹 Stream realtime status Bluetooth
  // ---------------------------------------------------------------------------
  /// Stream ini akan memancarkan status seperti:
  /// `on`, `off`, `turningOn`, `turningOff`, `enabled`, `disabled`
  static Stream<String> get bluetoothStateStream {
    return _stateChannel
        .receiveBroadcastStream()
        .map((event) => event.toString())
        .handleError((err) {
      log("⚠️ bluetoothStateStream error: $err");
      return 'error';
    });
  }

  // ---------------------------------------------------------------------------
  // 🔹 Mengecek apakah Bluetooth aktif
  // ---------------------------------------------------------------------------
  static Future<bool> isBluetoothEnabled() async {
    try {
      final result = await _methodChannel.invokeMethod('isBluetoothEnabled');
      return result == true;
    } catch (e) {
      log("⚠️ isBluetoothEnabled error: $e");
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 Menampilkan prompt sistem untuk mengaktifkan Bluetooth
  // ---------------------------------------------------------------------------
  static Future<bool> enableBluetooth() async {
    try {
      final result = await _methodChannel.invokeMethod('enableBluetooth');
      return result == true;
    } on PlatformException catch (e) {
      log("⚠️ enableBluetooth error: ${e.message}");
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 Gabungan logika check + enable dengan dialog custom
  // ---------------------------------------------------------------------------
  static Future<bool> ensureBluetoothEnabled({
    required Function onNeedConfirm,
  }) async {
    final isOn = await isBluetoothEnabled();
    if (isOn) return true;

    final confirm = await onNeedConfirm();
    if (confirm == true) {
      final enabled = await enableBluetooth();
      return enabled;
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // 🔹 Ambil daftar perangkat yang sudah dipasangkan
  // ---------------------------------------------------------------------------
  static Future<List<Map<String, String>>> getPairedDevices() async {
    try {
      final result = await _methodChannel.invokeMethod('getPairedDevices');
      return List<Map<String, String>>.from(result);
    } catch (e) {
      log("⚠️ getPairedDevices error: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 Mulai discovery perangkat baru
  // ---------------------------------------------------------------------------
  static Future<void> startDiscovery() async {
    try {
      await _methodChannel.invokeMethod('startDiscovery');
    } catch (e) {
      log("⚠️ startDiscovery error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 Hentikan discovery
  // ---------------------------------------------------------------------------
  static Future<void> stopDiscovery() async {
    try {
      await _methodChannel.invokeMethod('stopDiscovery');
    } catch (e) {
      log("⚠️ stopDiscovery error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 Putuskan koneksi aktif (jika ada)
  // ---------------------------------------------------------------------------
  static Future<void> disconnect() async {
    try {
      await _methodChannel.invokeMethod('disconnect');
    } catch (e) {
      log("⚠️ disconnect error: $e");
    }
  }
}
