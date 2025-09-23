import 'dart:async';
import 'package:flutter/services.dart';

class FlutterBluetoothClassic {
  static const MethodChannel _method =
      MethodChannel('flutter_bluetooth_classic/methods');
  static const EventChannel _discovery =
      EventChannel('flutter_bluetooth_classic/discovery');
  static const EventChannel _onData =
      EventChannel('flutter_bluetooth_classic/onData');
  static const EventChannel _state =
      EventChannel('flutter_bluetooth_classic/state');
  static const EventChannel _connection =
      EventChannel('flutter_bluetooth_classic/connection');

  // Internal streams
  static Stream<Map<dynamic, dynamic>>? _scanStream;
  static Stream<Map<dynamic, dynamic>>? _dataStream;
  static Stream<String>? _stateStream;
  static Stream<String>? _connectionStream;

  /// 🔍 Scan semua device (paired + unpaired)
  static Stream<Map<dynamic, dynamic>> startDiscovery() {
    _scanStream ??= _discovery.receiveBroadcastStream().map((event) {
      return Map<dynamic, dynamic>.from(event);
    });
    return _scanStream!;
  }

  /// 📥 Stream data masuk dari device
  static Stream<Map<dynamic, dynamic>> onDataReceived() {
    _dataStream ??= _onData.receiveBroadcastStream().map((event) {
      return Map<dynamic, dynamic>.from(event);
    });
    return _dataStream!;
  }

  /// 📡 Stream status Bluetooth: 'enabled', 'disabled', 'unsupported'
  static Stream<String> onStateChanged() {
    _stateStream ??=
        _state.receiveBroadcastStream().map((event) => event.toString());
    return _stateStream!;
  }

  /// 🔌 Stream status koneksi device: 'connected:<address>', 'disconnected', 'failed:<address>'
  static Stream<String> onConnectionChanged() {
    _connectionStream ??=
        _connection.receiveBroadcastStream().map((event) => event.toString());
    return _connectionStream!;
  }

  /// ✅ Ambil list device yang sudah paired
  static Future<List<Map<String, String>>> getPairedDevices() async {
    final devices = await _method.invokeMethod('getPairedDevices');
    return List<Map<String, String>>.from(
      devices.map((d) => Map<String, String>.from(d)),
    );
  }

  /// 🔗 Connect insecure (tanpa pairing)
  static Future<bool> connectInsecure(String address) async {
    final ok =
        await _method.invokeMethod('connectInsecure', {'address': address});
    return ok == true;
  }

  /// ❌ Disconnect device
  static Future<void> disconnect() async {
    await _method.invokeMethod('disconnect');
  }

  /// 📤 Kirim data ke device
  static Future<bool> write(String data) async {
    final ok = await _method.invokeMethod('write', {'data': data});
    return ok == true;
  }

  /// 🔹 Cek support Bluetooth
  static Future<bool> isBluetoothSupported() async {
    final supported = await _method.invokeMethod('isBluetoothSupported');
    return supported == true;
  }

  /// 🔹 Cek Bluetooth aktif atau tidak
  static Future<bool> isBluetoothEnabled() async {
    final enabled = await _method.invokeMethod('isBluetoothEnabled');
    return enabled == true;
  }
}
