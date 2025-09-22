import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BtlinkcontrollerController extends GetxController {
  // MethodChannel & EventChannel
  static const _methodChannel = MethodChannel('bluetooth_channel');
  static const _eventChannel = EventChannel('bluetooth_event');

  // Observable state
  var devices = <Map<String, String>>[].obs;
  var isConnected = false.obs;
  var receivedData = ''.obs;

  StreamSubscription? _dataSubscription;

  @override
  void onInit() {
    super.onInit();
    // Listen incoming data
    _dataSubscription = _eventChannel.receiveBroadcastStream().listen((data) {
      receivedData.value = data.toString();
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    super.onClose();
    _dataSubscription?.cancel();
  }

  // Scan paired devices
  Future<void> scanDevices() async {
    try {
      final result = await _methodChannel.invokeMethod('scanDevices');
      devices.assignAll(List<Map<String, String>>.from(result));
    } catch (e) {
      log("Scan error: $e");
    }
  }

  // Connect
  Future<void> connect(String address) async {
    try {
      final success = await _methodChannel
          .invokeMethod('connectToDevice', {"address": address});
      isConnected.value = success ?? false;
    } catch (e) {
      log("Connect error: $e");
    }
  }

  // Send data
  Future<void> send(String data) async {
    if (!isConnected.value) return;
    try {
      await _methodChannel.invokeMethod('sendData', {"data": data});
    } catch (e) {
      log("Send error: $e");
    }
  }

  // Disconnect
  Future<void> disconnect() async {
    try {
      final success = await _methodChannel.invokeMethod('disconnect');
      isConnected.value = !(success ?? false);
    } catch (e) {
      log("Disconnect error: $e");
    }
  }
}
