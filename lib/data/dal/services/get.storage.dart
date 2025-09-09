// lib/services/storage_service.dart
import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  // Keys
  static const String isLoggedInKey = 'isLoggedIn';
  static const String usernameKey = 'username';
  static const String tokenKey = 'token';
  static const String bUrlKey = 'baseurl';
  static const String kebunKey = 'kebun';

  //? Fingerprint
  static const String condevSNKey = 'fpsn';
  static const String condevNameKey = 'fpname';
  static const String condevSensorKey = 'fpsensor';
  static const String condevCapacityKey = 'fpcap';
  static const String condevCapacityMaxKey = 'fpcapmax';
  static const String condevLogKey = 'fplog';
  static const String condevLogMaxKey = 'fplogmax';
  static const String condevTempKey = 'fptemp';
  static const String condevBatKey = 'fpbat';
  static const String condevFirmwareKey = 'fpfirm';
  static const String condevHardwareKey = 'fphard';
  static const String condevMacKey = 'fpmac';

  // Write
  Future<void> saveIsLoggedIn(bool value) async =>
      _box.write(isLoggedInKey, value);
  Future<void> saveUsername(String username) async =>
      _box.write(usernameKey, username);
  Future<void> saveToken(String token) async => _box.write(tokenKey, token);
  Future<void> saveKebun(String token) async => _box.write(kebunKey, token);
  Future<void> saveBUrl(String bUrl) async => _box.write(bUrlKey, bUrl);
  Future<void> saveFPInfo(Map<String, dynamic> value) async {
    _box.write(condevSNKey, value['sn']);
    _box.write(condevNameKey, value['name']);
    _box.write(condevSensorKey, value['sensor']);
    _box.write(condevCapacityKey, value['capacity']);
    _box.write(condevCapacityMaxKey, value['capacitymax']);
    _box.write(condevTempKey, value['temp']);
    _box.write(condevBatKey, value['bat']);
    _box.write(condevFirmwareKey, value['firmware']);
    _box.write(condevHardwareKey, value['hardware']);
    _box.write(condevMacKey, value['mac']);
  }

  // Read
  bool get isLoggedIn => _box.read(isLoggedInKey) ?? false;
  String? get username => _box.read(usernameKey);
  String? get token => _box.read(tokenKey);
  String? get bUrl => _box.read(bUrlKey);
  String? get kebun => _box.read(kebunKey);
  String? get condevSN => _box.read(condevSNKey);
  String? get condevName => _box.read(condevNameKey);
  String? get condevSensor => _box.read(condevSensorKey);
  String? get condevCapacity => _box.read(condevCapacityKey);
  String? get condevCapacityMax => _box.read(condevCapacityMaxKey);
  String? get condevTemp => _box.read(condevTempKey);
  String? get condevBat => _box.read(condevBatKey);
  String? get condevFirmware => _box.read(condevFirmwareKey);
  String? get condevMac => _box.read(condevMacKey);
  String? get condevHardware => _box.read(condevHardwareKey);

  // Remove
  Future<void> clearAll() async => _box.erase();
  Future<void> removeToken() async => _box.remove(tokenKey);
}
