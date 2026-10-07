import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/network/auth_interceptors.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login_response.dart';

@lazySingleton
class AuthApiClient {
  AuthApiClient(this._dio);

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.login,
      data: request.toJson(),
      options: Options(extra: {AuthRequestExtra.skipRefresh: true}),
    );
    return LoginResponse.fromJson(_body(response.data));
  }
}

Map<String, dynamic> _body(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  throw const FormatException('Empty login response');
}
