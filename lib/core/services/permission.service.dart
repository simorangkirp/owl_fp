import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  /// Request single permission
  Future<bool> requestPermission(Permission permission) async {
    var status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      status = await permission.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Request semua permission Bluetooth yang dibutuhkan
  static Future<bool> requestBluetoothPermissions() async {
    // Android 12+ butuh ini
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    final advertise = await Permission.bluetoothAdvertise.request();

    // Android < 12 butuh lokasi
    final location = await Permission.locationWhenInUse.request();

    if (scan.isGranted &&
        connect.isGranted &&
        advertise.isGranted &&
        location.isGranted) {
      return true;
    }
    return false;
  }

  /// Cek apakah semua permission granted
  static Future<bool> hasBluetoothPermissions() async {
    return await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.bluetoothAdvertise.isGranted &&
        await Permission.locationWhenInUse.isGranted;
  }

  /// Request multiple permissions
  Future<Map<Permission, bool>> requestPermissions(
      List<Permission> permissions) async {
    final statuses = await permissions.request();
    return statuses.map(
      (permission, status) => MapEntry(permission, status.isGranted),
    );
  }

  /// Check if permission is granted
  Future<bool> isGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Open app settings
  Future<void> openSettings() async {
    await openAppSettings();
  }

  // ================================
  // OTA UPDATE PERMISSIONS
  // ================================

  /// Request full permissions needed for OTA update
  Future<bool> requestOtaPermissions() async {
    final permissions = [
      Permission.storage, // Android < 13
      Permission.manageExternalStorage, // Android 11+
      Permission.requestInstallPackages, // install APK
    ];

    bool granted = true;

    for (var p in permissions) {
      var status = await p.request();
      if (!status.isGranted) {
        granted = false;
      }
    }

    return granted;
  }

  /// Check all OTA permissions
  Future<bool> hasOtaPermissions() async {
    return await Permission.storage.isGranted &&
        await Permission.manageExternalStorage.isGranted &&
        await Permission.requestInstallPackages.isGranted;
  }
}
