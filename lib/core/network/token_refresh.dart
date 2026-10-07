import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';

/// Pair of tokens returned by a successful refresh (or login) operation.
class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken});

  final String accessToken;

  /// When null, the existing refresh token should be kept.
  final String? refreshToken;
}

/// Performs the HTTP refresh-token call.
abstract interface class TokenRefresher {
  /// Exchanges [refreshToken] for a new [AuthTokens] pair.
  ///
  /// Returns `null` when the body reports failure without an HTTP error.
  /// Throws [DioException] on transport or HTTP failure.
  Future<AuthTokens?> refresh(String refreshToken);
}

/// Calls `POST /api/identity/auth/refresh-token` on its own [Dio].
@LazySingleton(as: TokenRefresher)
class ApiTokenRefresher implements TokenRefresher {
  ApiTokenRefresher() : _dio = Dio(_options());

  final Dio _dio;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    return tokensFromRefreshBody(response.data);
  }
}

BaseOptions _options() {
  return BaseOptions(
    baseUrl: ApiEndpoints.resolvedBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: const {'Content-Type': 'application/json'},
  );
}

AuthTokens? tokensFromRefreshBody(Map<String, dynamic>? body) {
  if (body == null || body['status'] != true) return null;
  final data = body['data'];
  if (data is! Map) return null;
  final map = Map<String, dynamic>.from(data);
  final access = map['token'];
  if (access is! String || access.isEmpty) return null;
  final refresh = map['refreshToken'];
  final nextRefresh = refresh is String && refresh.isNotEmpty ? refresh : null;
  return AuthTokens(accessToken: access, refreshToken: nextRefresh);
}
