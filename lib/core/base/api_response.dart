import '../error/api_exception.dart';

class ApiResponse<T> {
  const ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
    this.pagination,
  });

  final bool status;
  final int code;
  final String message;
  final T? data;
  final Map<String, dynamic>? pagination;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'];
    final rawPagination = json['pagination'];

    return ApiResponse<T>(
      status: json['status'] as bool? ?? false,
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: rawData == null ? null : fromJsonT(rawData),
      pagination: rawPagination is Map<String, dynamic> ? rawPagination : null,
    );
  }
}

extension ApiResponseValidation<T> on ApiResponse<T> {
  T dataOrThrow() {
    if (!status || data == null) {
      throw ApiException(message: message, statusCode: code);
    }
    return data as T;
  }
}
