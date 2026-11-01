import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
  /// Returns `null` when refresh cannot be performed (not configured, or
  /// backend reported failure without a transport-level error).
  /// Throws [DioException] (or other) on transport/HTTP failure so the
  /// interceptor can distinguish network errors from auth expiration.
  Future<AuthTokens?> refresh(String refreshToken);
}

/// Real implementation calling `POST /api/identity/auth/refresh-token`.
///
/// Uses its own [Dio] instance (no [AuthInterceptors] attached) so the
/// refresh call can never trigger another refresh or get stuck in a loop.
/// The base URL is read when the call is made, after [ApiEndpoints.loadBaseUrl].
@LazySingleton(as: TokenRefresher)
class ApiTokenRefresher implements TokenRefresher {
  ApiTokenRefresher()
    : this._(Dio(_options), () => ApiEndpoints.resolvedBaseUrl);

  @visibleForTesting
  ApiTokenRefresher.testing({required Dio dio, String Function()? baseUrl})
    : this._(dio, baseUrl ?? (() => ApiEndpoints.resolvedBaseUrl));

  ApiTokenRefresher._(this._dio, this._baseUrl);

  static final BaseOptions _options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final Dio _dio;
  final String Function() _baseUrl;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    final configured = _baseUrl().trim();
    final baseUrl = configured.isNotEmpty ? configured : _dio.options.baseUrl;
    final origin = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final response = await _dio.post<dynamic>(
      '$origin${ApiEndpoints.refreshToken}',
      data: {'refreshToken': refreshToken},
      options: Options(
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final body = response.data;
    if (body is! Map || body['status'] != true) {
      return null;
    }

    final data = body['data'];
    if (data is! Map) {
      return null;
    }

    final accessToken = data['token'];
    if (accessToken is! String || accessToken.isEmpty) {
      return null;
    }

    final newRefreshToken = data['refreshToken'];
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: newRefreshToken is String && newRefreshToken.isNotEmpty
          ? newRefreshToken
          : null,
    );
  }
}
