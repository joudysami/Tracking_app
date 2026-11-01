import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/api/auth_api_client.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login/login_response.dart';

import '../../../support/recording_dio.dart';

void main() {
  const baseUrl = 'https://gateway.test/';

  test('posts login with email, password, and fcmToken', () async {
    final calls = <RecordedRequest>[];
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: calls,
      body: _loginBody(),
    );

    final response = await AuthApiClient(dio).login(
      LoginRequest(
        email: 'driver@example.com',
        password: 'Password1',
        fcmToken: '',
      ),
    );

    final request = calls.single;
    expect(request.method, 'POST');
    expect(
      request.uri.toString(),
      'https://gateway.test/api/identity/auth/login',
    );
    expect(request.data, {
      'email': 'driver@example.com',
      'password': 'Password1',
      'fcmToken': '',
    });
    expect(request.header('content-type'), contains('application/json'));
    expect(response.status, isTrue);
    expect(response.code, 200);
    expect(response.data?.accessToken, 'access-token');
    expect(response.data?.refreshToken, 'refresh-token');
    expect(response.data?.toDomain().role, 'DRIVER');
  });

  test('login parsing reads data.token from the documented envelope', () {
    final response = LoginResponse.fromJson(_loginBody());

    expect(response.data?.accessToken, 'access-token');
    expect(response.data?.refreshToken, 'refresh-token');
  });

  test('HTTP 200 with status false and null data does not throw', () async {
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: [],
      body: {
        'status': false,
        'code': 200,
        'message': 'Invalid credentials',
        'data': null,
      },
    );

    final response = await AuthApiClient(
      dio,
    ).login(LoginRequest(email: 'driver@example.com', password: 'Password1'));

    expect(response.status, isFalse);
    expect(response.data, isNull);
    expect(response.message, 'Invalid credentials');
  });

  test('missing or malformed token data parses as no session', () {
    final missing = LoginResponse.fromJson({
      'status': true,
      'code': 200,
      'message': 'Logged in',
      'data': {'user': <String, dynamic>{}},
    });
    final malformed = LoginResponse.fromJson({
      'status': true,
      'code': 200,
      'message': 'Logged in',
      'data': {'token': 15, 'refreshToken': ''},
    });

    expect(missing.data, isNull);
    expect(malformed.data, isNull);
  });

  test('a non-2xx login response is not parsed as success', () {
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: [],
      statusCode: 401,
      body: {
        'status': false,
        'code': 401,
        'message': 'Unauthorized',
        'data': null,
      },
    );

    expect(
      () => AuthApiClient(
        dio,
      ).login(LoginRequest(email: 'driver@example.com', password: 'Password1')),
      throwsA(
        isA<DioException>().having(
          (error) => error.response?.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
  });
}

Map<String, dynamic> _loginBody() {
  return {
    'status': true,
    'code': 200,
    'message': 'Logged in',
    'data': {
      'user': {
        'id': 'user-1',
        'roles': ['DRIVER'],
      },
      'token': 'access-token',
      'refreshToken': 'refresh-token',
    },
    'pagination': null,
    'errors': null,
  };
}
