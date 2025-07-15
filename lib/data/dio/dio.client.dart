import 'package:dio/dio.dart';

import '../../core/error/exception.handler.dart';

class DioClient {
  final Dio _dio;

  DioClient(String baseUrl)
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: 10000,
            receiveTimeout: 10000,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          ),
        ) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioError e) {
    // Tambahkan handling error sesuai kebutuhan
    throw ExceptionHandler.fromDioError(e);
  }
}
