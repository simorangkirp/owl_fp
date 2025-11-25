import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:owl_fp_newer/data/dio/dio.exception.dart';

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

  /// GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _retryRequest(() {
      return _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    }, "GET $path");
  }

  /// POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _retryRequest(() {
      return _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    }, "POST $path");
  }

  /// Retry Handler
  Future<Response> _retryRequest(
    Future<Response> Function() request,
    String stepName,
  ) async {
    int retry = 0;

    while (true) {
      try {
        return await request();
      } on DioError catch (e) {
        // cek timeout
        final isTimeout = e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout ||
            e.type == DioErrorType.sendTimeout;

        if (isTimeout && retry < maxRetry) {
          retry++;
          debugPrint("⏳ $stepName timeout, retry $retry/$maxRetry");

          DialogHelper.showRetrySnack(retry, maxRetry);

          await Future.delayed(retryDelay);
          continue;
        }

        // convert ke exception buatan kamu
        throw _mapDioError(e);
      }
    }
  }
}

Exception _mapDioError(DioError e) {
  // Timeout
  if (e.type == DioErrorType.connectTimeout ||
      e.type == DioErrorType.receiveTimeout ||
      e.type == DioErrorType.sendTimeout) {
    return TimeoutException();
  }

  // No Internet
  if (e.error is SocketException) {
    return NetworkException();
  }

  // Unexpected server response
  if (e.type == DioErrorType.response) {
    return ServerException(
      e.response?.data?["message"] ?? "Server error",
      e.response?.statusCode,
    );
  }

  // Default
  return DioException(
    e.message,
    e.response?.statusCode,
  );
}
