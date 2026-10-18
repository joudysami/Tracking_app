import 'package:dio/dio.dart';

class RecordedRequest {
  RecordedRequest(RequestOptions options)
    : method = options.method,
      uri = options.uri,
      query = Map<String, dynamic>.from(options.queryParameters),
      data = options.data,
      headers = Map<String, dynamic>.from(options.headers);

  final String method;
  final Uri uri;
  final Map<String, dynamic> query;
  final Object? data;
  final Map<String, dynamic> headers;

  String? header(String name) {
    final needle = name.toLowerCase();
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == needle) {
        return entry.value?.toString();
      }
    }
    return null;
  }
}

Dio recordingDio({
  required String baseUrl,
  required List<RecordedRequest> calls,
  int statusCode = 200,
  Object? body,
}) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        calls.add(RecordedRequest(options));
        final response = Response<Object?>(
          requestOptions: options,
          statusCode: statusCode,
          data: body,
        );
        if (statusCode >= 200 && statusCode < 300) {
          handler.resolve(response);
          return;
        }
        handler.reject(
          DioException(
            requestOptions: options,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      },
    ),
  );
  return dio;
}
