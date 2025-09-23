// core/api/api_exception.dart

class DioException implements Exception {
  final String message;
  final int? code;

  DioException(this.message, [this.code]);

  @override
  String toString() => 'DioException($code): $message';
}

class NetworkException extends DioException {
  NetworkException() : super('Tidak ada koneksi internet');
}

class TimeoutException extends DioException {
  TimeoutException() : super('Waktu koneksi habis');
}

class ServerException extends DioException {
  ServerException(String message, [int? code]) : super(message, code);
}
