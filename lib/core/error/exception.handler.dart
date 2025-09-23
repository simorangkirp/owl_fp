import 'package:dio/dio.dart';

import 'app.exception.dart';

class ExceptionHandler {
  static AppException fromDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return AppException('Connection Timeout');
      case DioErrorType.receiveTimeout:
        return AppException('Receive Timeout');
      case DioErrorType.sendTimeout:
        return AppException('Send Timeout');
      case DioErrorType.response:
        final statusCode = error.response?.statusCode ?? 0;
        final msg = error.response?.data['message'] ?? 'Unknown Error';
        return AppException('[$statusCode] $msg', code: statusCode.toString());
      case DioErrorType.cancel:
        return AppException('Request Cancelled');
      case DioErrorType.other:
      default:
        return AppException('Unexpected error occurred');
    }
  }
}
