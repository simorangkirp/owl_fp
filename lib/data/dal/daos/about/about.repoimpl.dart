import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:owl_fp_newer/core/resources/data.state.dart';
import 'package:owl_fp_newer/data/dal/services/apis/about.api.dart';
import 'package:owl_fp_newer/domain/repository/about.repo.dart';

class AboutRepoImpl implements AboutRepository {
  final AboutRemoteDataSource remoteDataSource;

  AboutRepoImpl(this.remoteDataSource);

  @override
  Future<DataState> getVersion() async {
    final payload = {'appname': 'com.owl.dma', 'appid': 'owlmobile'};

    try {
      final httpResp = await remoteDataSource.version(payload);
      final statusCode = httpResp.response.statusCode ?? 500;
      final data = httpResp.data;

      switch (statusCode) {
        case HttpStatus.ok:
          if (data is! Map) {
            return const DataError(
              "Format respons server tidak sesuai (bukan JSON).",
            );
          }

          if (data["error"] == true) {
            return DataError(data["message"]);
          }

          final result = data['result'];
          if (result == null) {
            return const DataError(
              "Respons server tidak memiliki field 'result'.",
            );
          }

          log("Request Success. App Version: ${result['app_version']}");
          return DataSuccess(data);

        case HttpStatus.requestTimeout:
          return const DataError("Request timeout");

        case 302:
          return const DataError(
            "Periksa base URL atau endpoint API yang digunakan.",
          );

        default:
          log("Unhandled status code: $statusCode");
          return DataError(data);
      }
    } on DioError catch (e) {
      log("DioError: ${e.message}");

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return const DataError("Connection Timeout");
      }

      if (e.error is SocketException) {
        return const DataError(
            "Tidak dapat terhubung ke server. Periksa URL atau koneksi internet Anda.");
      }

      if (e.error is HandshakeException) {
        return const DataError(
            "Gagal melakukan koneksi aman (SSL). Pastikan URL benar dan sertifikat valid.");
      }

      return DataError(e.message);
    } catch (e) {
      return DataError("Unexpected error: $e");
    }
  }

  @override
  Future<DataState<String>> downloadLatestVersion({
    Function(int received, int total)? onProgress,
  }) async {
    try {
      // 1️⃣ Ambil versi terbaru
      final versionState = await getVersion();
      if (versionState is DataError) {
        return DataError(versionState.error ?? "Gagal mengambil versi.");
      }

      final json = (versionState as DataSuccess).data;
      final result = json["result"];

      final apkUrl = result["url"];
      if (apkUrl == null) {
        return const DataError("Server tidak mengirim URL APK.");
      }

      log("🔽 Downloading APK from: $apkUrl");

      // 2️⃣ Panggil RemoteDataSource downloadApk
      final savePath = await remoteDataSource.downloadApk(
        apkUrl,
        onProgress: onProgress,
      );

      log("📦 APK berhasil di-download: $savePath");

      return DataSuccess(savePath);
    } on Exception catch (e) {
      return DataError(e.toString());
    } catch (e) {
      return DataError("Unexpected error: $e");
    }
  }
}
