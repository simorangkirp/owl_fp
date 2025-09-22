import 'package:flutter/services.dart';

class BluetoothService {
  static const _methodChannel = MethodChannel('bluetooth_channel');
  static const _eventChannel = EventChannel('bluetooth_event');

  // Stream untuk menerima data dari device
  static Stream<String> get onDataReceived =>
      _eventChannel.receiveBroadcastStream().map((event) => event.toString());

  static Future<List<Map<String, String>>> scanDevices() async {
    final result = await _methodChannel.invokeMethod('scanDevices');
    return List<Map<String, String>>.from(result);
  }

  static Future<bool> connect(String address) async {
    return await _methodChannel
        .invokeMethod('connectToDevice', {"address": address});
  }

  static Future<bool> send(String data) async {
    return await _methodChannel.invokeMethod('sendData', {"data": data});
  }

  static Future<bool> disconnect() async {
    return await _methodChannel.invokeMethod('disconnect');
  }
}
