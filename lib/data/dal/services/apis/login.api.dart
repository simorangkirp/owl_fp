import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../dio/dio.client.dart';
import '../get.storage.dart';

abstract class AuthRemoteDataSource {
  Future<HttpResponse<dynamic>> login(
    Map<String, dynamic> payload,
  );
  Future<HttpResponse<dynamic>> profile();
  Future<HttpResponse<dynamic>> getMasterData();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});
  var box = StorageService.instance;

  @override
  Future<HttpResponse<dynamic>> login(Map<String, dynamic> payload) async {
    try {
      final Response response = await dioClient.post(
        '${box.bUrl}/login',
        data: payload,
        options: Options(
          followRedirects: false, // 🔒 penting biar 302 gak diikuti otomatis
          validateStatus: (status) => status != null && status < 500,
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
      log("❌ DioError di remoteDataSource.login(): ${e.message}");

      if (e.response != null) {
        log("🧭 Status code: ${e.response?.statusCode}");
        log("🧾 Response body: ${e.response?.data}");
      }

      rethrow; // biar repository nangkep
    } catch (e) {
      log("🔥 Unexpected error di remoteDataSource.login(): $e");
      rethrow;
    }
  }

  @override
  // =============================================================
  // PROFILE
  // =============================================================
  Future<HttpResponse<dynamic>> profile() async {
    try {
      final Response response = await dioClient.post(
        '${box.bUrl}/profile',
        options: Options(
          headers: {'api_key': box.token},
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log("HTTP STATUS (PROFILE): ${response.statusCode}");

      dynamic value = response.data;

      if (value is String) {
        try {
          value = jsonDecode(value);
        } catch (_) {
          log("⚠️ Respons profile bukan JSON, kemungkinan base URL salah");
          value = {
            "error": true,
            "message":
                "Respons server bukan JSON. Periksa base URL / token Anda.",
          };
        }
      }

      return HttpResponse(value, response);
    } on DioError catch (e) {
      log("❌ DioError (profile): ${e.message}");
      if (e.response != null) {
        log("🧭 Status code: ${e.response?.statusCode}");
        log("🧾 Response body: ${e.response?.data}");
      }
      rethrow;
    } catch (e) {
      log("🔥 Unexpected error (profile): $e");
      rethrow;
    }
  }

  @override
  // =============================================================
  // MASTER DATA
  // =============================================================
  Future<HttpResponse<dynamic>> getMasterData() async {
    try {
      final Response response = await dioClient.post(
        '${box.bUrl}/module/setupmasterdata/getmasterdata/load',
        options: Options(
          headers: {'api_key': box.token},
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log("HTTP STATUS (MASTER DATA): ${response.statusCode}");

      dynamic value = response.data;

      if (value is String) {
        try {
          value = jsonDecode(value);
        } catch (_) {
          log("⚠️ Respons master data bukan JSON, kemungkinan base URL salah");
          value = {
            "error": true,
            "message":
                "Server mengembalikan data non-JSON. Pastikan URL dan token valid.",
          };
        }
      }

      return HttpResponse(value, response);
    } on DioError catch (e) {
      log("❌ DioError (getMasterData): ${e.message}");
      if (e.response != null) {
        log("🧭 Status code: ${e.response?.statusCode}");
        log("🧾 Response body: ${e.response?.data}");
      }
      rethrow;
    } catch (e) {
      log("🔥 Unexpected error (getMasterData): $e");
      rethrow;
    }
  }
}
