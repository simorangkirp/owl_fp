import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/error/exception.handler.dart';
import '../../core/resources/utils.dart';

class DioClient {
  final Dio _dio;
  final int maxRetry;
  final Duration retryDelay;

  DioClient(
    String baseUrl, {
    this.maxRetry = 2,
    this.retryDelay = const Duration(seconds: 1),
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: 20000,
            receiveTimeout: 60000,
            sendTimeout: 20000,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            responseType: ResponseType.json,
          ),
        ) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  /// 🔹 GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _retryRequest(() async {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    }, "GET $path");
  }

  /// 🔹 POST request
  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _retryRequest(() async {
      return await _dio.post(
        path,
        data: data ?? {},
        queryParameters: queryParameters,
        options: options,
      );
    }, "POST $path");
  }

  /// 🔹 Retry wrapper + auto cancel
  Future<Response> _retryRequest(
    Future<Response> Function() request,
    String stepName,
  ) async {
    int retry = 0;
    final cancelToken = CancelToken();

    while (true) {
      try {
        return await request();
      } catch (e) {
        if (e is DioError &&
            (e.type == DioErrorType.connectTimeout ||
                e.type == DioErrorType.receiveTimeout ||
                e.type == DioErrorType.sendTimeout) &&
            retry < maxRetry) {
          retry++;
          debugPrint("⏳ $stepName timeout, coba ulang ($retry/$maxRetry)...");
          DialogHelper.showRetrySnack(retry, maxRetry);
          await Future.delayed(retryDelay);
          continue;
        }

        // ❌ Batalkan request kalau sudah max retry
        if (retry >= maxRetry && !cancelToken.isCancelled) {
          cancelToken
              .cancel("Request dibatalkan setelah $maxRetry kali retry.");
        }

        throw ExceptionHandler.fromDioError(e as DioError);
      }
    }
  }
}
