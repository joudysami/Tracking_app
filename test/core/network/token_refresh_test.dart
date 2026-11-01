import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/network/token_refresh.dart';

import '../../support/recording_dio.dart';

void main() {
  const baseUrl = 'https://gateway.test/';

  test('posts the documented refresh route and reads data.token', () async {
    final calls = <RecordedRequest>[];
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: calls,
      body: _refreshBody(token: 'new-access', refreshToken: 'new-refresh'),
    );

    final tokens = await ApiTokenRefresher.testing(
      dio: dio,
      baseUrl: () => baseUrl,
    ).refresh('old-refresh');

    final request = calls.single;
    expect(request.method, 'POST');
    expect(
      request.uri.toString(),
      'https://gateway.test/api/identity/auth/refresh-token',
    );
    expect(request.data, {'refreshToken': 'old-refresh'});
    expect(request.header('content-type'), contains('application/json'));
    expect(request.header('Accept'), 'application/json');
    expect(tokens?.accessToken, 'new-access');
    expect(tokens?.refreshToken, 'new-refresh');
  });

  test('returns null when the refresh envelope reports failure', () async {
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: [],
      body: {
        'status': false,
        'code': 200,
        'message': 'Token refreshed',
        'data': null,
      },
    );

    final tokens = await ApiTokenRefresher.testing(
      dio: dio,
      baseUrl: () => baseUrl,
    ).refresh('old-refresh');

    expect(tokens, isNull);
  });

  test('returns null when a success envelope has no token', () async {
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: [],
      body: {
        'status': true,
        'code': 200,
        'message': 'Token refreshed',
        'data': {'refreshToken': 'new-refresh'},
      },
    );

    final tokens = await ApiTokenRefresher.testing(
      dio: dio,
      baseUrl: () => baseUrl,
    ).refresh('old-refresh');

    expect(tokens, isNull);
  });

  test('throws when refresh is rejected', () async {
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: [],
      statusCode: 401,
      body: {'status': false, 'code': 401, 'message': 'Unauthorized'},
    );

    expect(
      () => ApiTokenRefresher.testing(
        dio: dio,
        baseUrl: () => baseUrl,
      ).refresh('old-refresh'),
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

Map<String, dynamic> _refreshBody({
  required String token,
  required String refreshToken,
}) {
  return {
    'status': true,
    'code': 200,
    'message': 'Token refreshed',
    'data': {'token': token, 'refreshToken': refreshToken},
    'pagination': null,
    'errors': null,
  };
}
