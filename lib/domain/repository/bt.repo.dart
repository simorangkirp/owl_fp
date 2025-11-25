import 'package:owl_fp_newer/domain/entity/bt.entity.dart';

abstract class BluetoothRepository {
  /// 🔍 Memulai scan dan mengembalikan stream device yang ditemukan.
  Stream<BluetoothDeviceEntity> startDiscovery();

  /// ⛔ Menghentikan scan jika masih berjalan.
  Future<void> cancelDiscovery();

  /// 🔗 Koneksi ke device.
  Future<bool> connectDevice(BluetoothDeviceEntity device);

  /// 🤝 Kirim handshake ke device.
  Future<void> sendHandshake();

  /// ⏳ Tunggu respons handshake (opsional, bisa mock).
  Future<bool> waitForHandshake({int timeout = 5});

  /// 📡 Ambil data dari device (WiFi, info, dsb.)
  Future<void> fetchDeviceData();

  /// 🔌 Putuskan koneksi device.
  Future<void> disconnectDevice();

  /// 🔢 Ambil daftar device yang sudah paired.
  Future<List<BluetoothDeviceEntity>> getPairedDevices();

  /// 💬 Kirim command Bluetooth (return true jika sukses).
  Future<bool> sendCommand(String command, {String? desc});

  /// 🧭 Cek apakah device masih terkoneksi.
  Future<bool> isConnected();

  /// Geting Init Value from Device
  Future<void> fetchInitValue();

  /// 🔔 Listener setup untuk Bluetooth event.
  Future<void> initListeners({
    Function(String state)? onStateChanged,
    Function(String conn)? onConnectionChanged,
    Function(String data)? onDataReceived,
    Function(String result)? onResultReceived, // 👈 tambahin juga di abstract
  });
}
