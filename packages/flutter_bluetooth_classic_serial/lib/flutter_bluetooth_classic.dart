import 'dart:async';
import 'package:flutter/services.dart';

class FlutterBluetoothClassic {
  static const MethodChannel _method =
      MethodChannel("flutter_bluetooth_classic/methods");
  static const EventChannel _discovery =
      EventChannel("flutter_bluetooth_classic/discovery");
  static const EventChannel _onData =
      EventChannel("flutter_bluetooth_classic/onData");

  static Stream<Map<dynamic, dynamic>>? _scanStream;
  static Stream<Map<dynamic, dynamic>>? _dataStream;

  /// 🔍 Scan semua device (paired + unpaired)
  static Stream<Map<dynamic, dynamic>> startDiscovery() {
    _scanStream ??= _discovery.receiveBroadcastStream().map((event) {
      return Map<dynamic, dynamic>.from(event);
    });
    return _scanStream!;
  }

  /// ✅ Ambil list device yang sudah paired
  static Future<List<Map<dynamic, dynamic>>> getPairedDevices() async {
    final devices = await _method.invokeMethod("getPairedDevices");
    return List<Map<dynamic, dynamic>>.from(
      devices.map((d) => Map<dynamic, dynamic>.from(d)),
    );
  }

  /// 🔗 Connect tanpa harus paired
  static Future<bool> connectInsecure(String address) async {
    final ok =
        await _method.invokeMethod("connectInsecure", {"address": address});
    return ok == true;
  }

  /// ❌ Disconnect
  static Future<void> disconnect() async {
    await _method.invokeMethod("disconnect");
  }

  /// 📤 Kirim data
  static Future<bool> write(String data) async {
    final ok = await _method.invokeMethod("write", {"data": data});
    return ok == true;
  }

  /// 📥 Stream data masuk dari device
  static Stream<Map<dynamic, dynamic>> onData() {
    _dataStream ??= _onData.receiveBroadcastStream().map((event) {
      return Map<dynamic, dynamic>.from(event);
    });
    return _dataStream!;
  }
}
