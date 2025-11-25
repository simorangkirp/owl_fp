import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dio.client.dart';

extension DioClientX on DioClient {
  /// Tempat aman buat simpan APK / cache / update
  Future<Directory> getAppDirectory() async {
    final dir = await getApplicationSupportDirectory();

    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }

    return dir;
  }
}
