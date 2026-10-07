import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/error/error_parser.dart';
import 'package:tracking_app/core/network/token_refresh.dart';
import 'package:dio/dio.dart';

void main() {
  test('android emulator rewrites loopback to 10.0.2.2', () {
    final url = ApiEndpoints.rewriteHostForLocalClient(
      'http://127.0.0.1:8080',
      androidEmulator: true,
      iosSimulator: false,
    );
    expect(url, 'http://10.0.2.2:8080');
  });

  test('base url does not append /api/v1', () {
    expect(
      ApiEndpoints.normalizeBaseUrl('http://127.0.0.1:8080'),
      'http://127.0.0.1:8080/',
    );
    expect(ApiEndpoints.login, '/api/identity/auth/login');
    expect(ApiEndpoints.refreshToken, '/api/identity/auth/refresh-token');
  });

  test('refresh body uses token and refreshToken', () {
    final tokens = tokensFromRefreshBody({
      'status': true,
      'message': 'Token refreshed',
      'data': {'token': 'next-access', 'refreshToken': 'next-refresh'},
    });
    expect(tokens?.accessToken, 'next-access');
    expect(tokens?.refreshToken, 'next-refresh');
  });

  test('identity error list is a credential message, not a crash', () {
    final error = errorParser(
      DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.login),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          statusCode: 400,
          data: {
            'status': false,
            'message': 'Validation failed',
            'errors': [
              {
                'message': 'Invalid email or password',
                'field': 'Request.Email',
              },
              {
                'message': 'Invalid email or password',
                'field': 'Request.Password',
              },
            ],
          },
        ),
      ),
    );

    expect(error, isA<BadResponseError>());
    expect(error.message, 'Invalid email or password');
  });
}
