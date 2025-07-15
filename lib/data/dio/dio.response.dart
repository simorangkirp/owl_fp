// core/api/api_response.dart

class DioResponse<T> {
  final T? data;
  final String? message;
  final bool success;

  DioResponse({this.data, this.message, required this.success});
}
