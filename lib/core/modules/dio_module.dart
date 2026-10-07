import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/network/auth_interceptors.dart';

@module
abstract class DioModule {
  @singleton
  Dio provideDio(AuthInterceptors authInterceptors) {
    final dio = Dio(_options());
    dio.interceptors.add(authInterceptors);
    authInterceptors.attachDio(dio);
    if (kDebugMode) dio.interceptors.add(_uriLogger());
    return dio;
  }
}

BaseOptions _options() {
  return BaseOptions(
    baseUrl: ApiEndpoints.resolvedBaseUrl,
    receiveTimeout: const Duration(seconds: 60),
    connectTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
    headers: const {'Content-Type': 'application/json'},
  );
}

Interceptor _uriLogger() {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint('${options.method} ${options.uri}');
      handler.next(options);
    },
    onError: (error, handler) {
      final code = error.response?.statusCode ?? error.type.name;
      debugPrint('$code ${error.requestOptions.uri}');
      handler.next(error);
    },
  );
}
