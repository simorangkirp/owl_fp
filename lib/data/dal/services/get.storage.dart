// lib/services/storage_service.dart
import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  // Keys
  static const String isLoggedInKey = 'isLoggedIn';
  static const String usernameKey = 'username';
  static const String tokenKey = 'token';
  static const String bUrlKey = 'baseurl';

  // Write
  Future<void> saveIsLoggedIn(bool value) async =>
      _box.write(isLoggedInKey, value);
  Future<void> saveUsername(String username) async =>
      _box.write(usernameKey, username);
  Future<void> saveToken(String token) async => _box.write(tokenKey, token);
  Future<void> saveBUrl(String bUrl) async => _box.write(bUrlKey, bUrl);

  // Read
  bool get isLoggedIn => _box.read(isLoggedInKey) ?? false;
  String? get username => _box.read(usernameKey);
  String? get token => _box.read(tokenKey);
  String? get bUrl => _box.read(bUrlKey);

  // Remove
  Future<void> clearAll() async => _box.erase();
  Future<void> removeToken() async => _box.remove(tokenKey);
}
