import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:owl_fp_newer/data/dal/services/get.storage.dart';
import 'package:owl_fp_newer/data/dio/dio.client.extension.dart';
import 'package:retrofit/retrofit.dart';
import '../../../dio/dio.client.dart';

abstract class AboutRemoteDataSource {
  Future<HttpResponse<dynamic>> version(
    Map<String, dynamic> payload,
  );
  Future<String> downloadApk(
    String url, {
    Function(int received, int total)? onProgress,
  });
}

class AboutRemoteDataSourceImpl extends AboutRemoteDataSource {
  final DioClient dioClient;

  AboutRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService.instance;

  @override
  Future<HttpResponse> version(Map<String, dynamic> payload) async {
    try {
      final Response response = await dioClient.post(
        '${box.bUrl}/module/setupversion/setupversion/load',
        data: payload,
        options: Options(
          followRedirects: false, // 🔒 penting biar 302 gak diikuti otomatis
          validateStatus: (status) => status != null && status < 500,
          headers: {'api_key': box.token},
        ),
      );

      log("HTTP STATUS : ${response.statusCode}");

      dynamic value = response.data;

      // 🔍 Cek kalau response bukan Map (misalnya String HTML)
      if (value is String) {
        try {
          // coba parse manual JSON
          value = jsonDecode(value);
        } catch (_) {
          // kalau gagal parse -> berarti bukan JSON (HTML / error page)
          log("⚠️ Respons bukan JSON, kemungkinan salah URL / endpoint");
          value = {
            "error": true,
            "message":
                "Server mengembalikan respons non-JSON. Periksa base URL / endpoint API.",
          };
        }
      }

      // Balikin response aman
      final httpResponse = HttpResponse(value, response);
      return httpResponse;
    } on DioError catch (e) {
      log("❌ DioError di remoteDataSource.version(): ${e.message}");

      if (e.response != null) {
        log("🧭 Status code: ${e.response?.statusCode}");
        log("🧾 Response body: ${e.response?.data}");
      }

      rethrow; // biar repository nangkep
    } catch (e) {
      log("🔥 Unexpected error di remoteDataSource.version(): $e");
      rethrow;
    }
  }

  @override
  Future<String> downloadApk(
    String url, {
    Function(int received, int total)? onProgress,
  }) async {
    try {
      log("🔽 Starting APK download from: $url");

      // Lokasi aman untuk menyimpan file APK di Android
      final dir = await dioClient.getAppDirectory();
      final savePath = "${dir.path}/update-latest.apk";

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (onProgress != null) onProgress(received, total);
        },
        options: Options(
          followRedirects: true,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 500,
        ),
      );

      final file = File(savePath);
      if (!file.existsSync() || file.lengthSync() < 10000) {
        throw Exception("File APK rusak atau tidak lengkap");
      }

      log("📦 APK downloaded to: $savePath");

      return savePath;
    } on DioError catch (e) {
      log("❌ DioError saat download APK: ${e.message}");

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw Exception("Timeout saat download APK");
      }

      if (e.error is SocketException) {
        throw Exception("Tidak ada koneksi internet");
      }

      throw Exception("Gagal download APK: ${e.message}");
    } catch (e) {
      log("🔥 Unexpected error saat download APK: $e");
      throw Exception(e.toString());
    }
  }
}
