import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/network/auth_interceptors.dart';
import 'package:tracking_app/core/network/token_refresh.dart';
import 'package:tracking_app/core/network/token_storage.dart';

import '../../support/recording_dio.dart';

const _baseUrl = 'https://gateway.test/';

void main() {
  test(
    'retries the original request once after a successful refresh',
    () async {
      final apiCalls = <RecordedRequest>[];
      final refreshCalls = <RecordedRequest>[];
      final storage = _MemoryTokenStorage(
        accessToken: 'old-access',
        refreshToken: 'old-refresh',
      );
      final refreshDio = recordingDio(
        baseUrl: _baseUrl,
        calls: refreshCalls,
        body: {
          'status': true,
          'code': 200,
          'message': 'Token refreshed',
          'data': {'token': 'new-access', 'refreshToken': 'new-refresh'},
        },
      );
      final api = Dio(BaseOptions(baseUrl: _baseUrl));
      api.httpClientAdapter = _StatusAdapter((options) {
        apiCalls.add(RecordedRequest(options));
        final authorization =
            options.headers['Authorization'] ??
            options.headers['authorization'];
        if (authorization == 'Bearer old-access') {
          return _jsonBody(401, {'message': 'unauthorized'});
        }
        return _jsonBody(200, {'ok': true});
      });
      final interceptors = AuthInterceptors(
        storage,
        ApiTokenRefresher.testing(dio: refreshDio, baseUrl: () => _baseUrl),
        AuthSessionNotifier(),
      );
      api.interceptors.add(interceptors);
      interceptors.attachDio(api);

      final response = await api.get<Map<String, dynamic>>(
        '/api/orders/drivers/available-orders',
      );

      expect(response.statusCode, 200);
      expect(response.data, {'ok': true});
      expect(refreshCalls, hasLength(1));
      expect(
        refreshCalls.single.uri.toString(),
        'https://gateway.test/api/identity/auth/refresh-token',
      );
      expect(refreshCalls.single.data, {'refreshToken': 'old-refresh'});
      expect(apiCalls, hasLength(2));
      expect(apiCalls.first.header('Authorization'), 'Bearer old-access');
      expect(apiCalls.last.header('Authorization'), 'Bearer new-access');
      expect(apiCalls.last.uri.toString(), apiCalls.first.uri.toString());
      expect(storage.accessToken, 'new-access');
      expect(storage.refreshToken, 'new-refresh');
    },
  );

  test('does not retry when refresh is rejected', () async {
    final apiCalls = <RecordedRequest>[];
    final storage = _MemoryTokenStorage(
      accessToken: 'old-access',
      refreshToken: 'old-refresh',
    );
    final refreshDio = recordingDio(
      baseUrl: _baseUrl,
      calls: [],
      statusCode: 401,
      body: {'status': false, 'code': 401, 'message': 'Unauthorized'},
    );
    final api = Dio(BaseOptions(baseUrl: _baseUrl));
    api.httpClientAdapter = _StatusAdapter((options) {
      apiCalls.add(RecordedRequest(options));
      return _jsonBody(401, {'message': 'unauthorized'});
    });
    final session = AuthSessionNotifier();
    var expired = 0;
    session.addListener(() => expired++);
    final interceptors = AuthInterceptors(
      storage,
      ApiTokenRefresher.testing(dio: refreshDio, baseUrl: () => _baseUrl),
      session,
    );
    api.interceptors.add(interceptors);
    interceptors.attachDio(api);

    await expectLater(
      api.get<void>('/api/orders/drivers/available-orders'),
      throwsA(
        isA<DioException>().having(
          (error) => error.error,
          'error',
          isA<ForceLogin>(),
        ),
      ),
    );
    expect(apiCalls, hasLength(1));
    expect(storage.accessToken, isNull);
    expect(storage.refreshToken, isNull);
    expect(expired, 1);
  });

  test(
    'leaves the original 401 in place when no refresh token is stored',
    () async {
      final storage = _MemoryTokenStorage(accessToken: 'old-access');
      final api = Dio(BaseOptions(baseUrl: _baseUrl));
      api.httpClientAdapter = _StatusAdapter(
        (options) => _jsonBody(401, {'message': 'unauthorized'}),
      );
      final interceptors = AuthInterceptors(
        storage,
        ApiTokenRefresher.testing(
          dio: recordingDio(baseUrl: _baseUrl, calls: [], body: {}),
          baseUrl: () => _baseUrl,
        ),
        AuthSessionNotifier(),
      );
      api.interceptors.add(interceptors);
      interceptors.attachDio(api);

      await expectLater(
        api.get<void>('/api/orders/drivers/available-orders'),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
      expect(storage.accessToken, 'old-access');
    },
  );

  test('keeps tokens when refresh returns status false', () async {
    final result = await _refreshFailure(
      body: {
        'status': false,
        'code': 200,
        'message': 'Refresh rejected',
        'data': null,
      },
    );

    expect(result.error.response?.statusCode, 401);
    expect(result.error.error, isNot(isA<ForceLogin>()));
    expect(result.apiCalls, hasLength(1));
    expect(result.refreshCalls, hasLength(1));
    expect(result.storage.accessToken, 'old-access');
    expect(result.storage.refreshToken, 'old-refresh');
    expect(result.expired, 0);
  });

  test('keeps tokens when the refresh envelope has no token', () async {
    final result = await _refreshFailure(
      body: {
        'status': true,
        'code': 200,
        'message': 'Token refreshed',
        'data': {'refreshToken': 'unused'},
      },
    );

    expect(result.error.response?.statusCode, 401);
    expect(result.error.error, isNot(isA<ForceLogin>()));
    expect(result.apiCalls, hasLength(1));
    expect(result.storage.accessToken, 'old-access');
    expect(result.storage.refreshToken, 'old-refresh');
    expect(result.expired, 0);
  });

  test('clears the session when refresh returns 400', () async {
    final result = await _refreshFailure(statusCode: 400);

    expect(result.error.error, isA<ForceLogin>());
    expect(result.apiCalls, hasLength(1));
    expect(result.refreshCalls, hasLength(1));
    expect(result.storage.accessToken, isNull);
    expect(result.storage.refreshToken, isNull);
    expect(result.expired, 1);
  });

  test('keeps tokens when refresh fails with a server error', () async {
    final result = await _refreshFailure(statusCode: 503);

    expect(result.error.response?.statusCode, 401);
    expect(result.error.error, isNot(isA<ForceLogin>()));
    expect(result.apiCalls, hasLength(1));
    expect(result.refreshCalls, hasLength(1));
    expect(result.storage.accessToken, 'old-access');
    expect(result.storage.refreshToken, 'old-refresh');
    expect(result.expired, 0);
  });

  test('keeps tokens when refresh fails before a response', () async {
    final result = await _refreshFailure(connectionError: true);

    expect(result.error.response?.statusCode, 401);
    expect(result.error.error, isNot(isA<ForceLogin>()));
    expect(result.apiCalls, hasLength(1));
    expect(result.refreshCalls, isEmpty);
    expect(result.storage.accessToken, 'old-access');
    expect(result.storage.refreshToken, 'old-refresh');
    expect(result.expired, 0);
  });

  test(
    'keeps the new tokens when the single retry fails transiently',
    () async {
      final result = await _refreshThenRetry(retryStatus: 503);

      expect(result.error.response?.statusCode, 503);
      expect(result.error.error, isNot(isA<ForceLogin>()));
      expect(result.apiCalls, hasLength(2));
      expect(result.refreshCalls, hasLength(1));
      expect(result.apiCalls.last.header('Authorization'), 'Bearer new-access');
      expect(result.storage.accessToken, 'new-access');
      expect(result.storage.refreshToken, 'new-refresh');
      expect(result.expired, 0);
    },
  );

  test('clears the session when the single retry is unauthorized', () async {
    final result = await _refreshThenRetry(retryStatus: 401);

    expect(result.error.error, isA<ForceLogin>());
    expect(result.apiCalls, hasLength(2));
    expect(result.refreshCalls, hasLength(1));
    expect(result.storage.accessToken, isNull);
    expect(result.storage.refreshToken, isNull);
  });
}

Future<_RefreshResult> _refreshFailure({
  int statusCode = 200,
  Map<String, dynamic>? body,
  bool connectionError = false,
}) async {
  final apiCalls = <RecordedRequest>[];
  final refreshCalls = <RecordedRequest>[];
  final storage = _MemoryTokenStorage(
    accessToken: 'old-access',
    refreshToken: 'old-refresh',
  );
  final Dio refreshDio;
  if (connectionError) {
    refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
    refreshDio.httpClientAdapter = _ThrowingAdapter(
      DioException(
        requestOptions: RequestOptions(
          path: '/api/identity/auth/refresh-token',
        ),
        type: DioExceptionType.connectionError,
        message: 'connection failed',
      ),
    );
  } else {
    refreshDio = recordingDio(
      baseUrl: _baseUrl,
      calls: refreshCalls,
      statusCode: statusCode,
      body: body ?? {'status': false, 'message': 'failed'},
    );
  }
  final session = AuthSessionNotifier();
  var expired = 0;
  session.addListener(() => expired++);
  final api = _api(
    storage: storage,
    refreshDio: refreshDio,
    session: session,
    apiCalls: apiCalls,
    respond: (options) => _jsonBody(401, {'message': 'unauthorized'}),
  );

  late DioException error;
  try {
    await api.get<void>('/api/orders/drivers/available-orders');
  } on DioException catch (caught) {
    error = caught;
  }
  return _RefreshResult(
    error: error,
    apiCalls: apiCalls,
    refreshCalls: refreshCalls,
    storage: storage,
    expired: expired,
  );
}

Future<_RefreshResult> _refreshThenRetry({required int retryStatus}) async {
  final apiCalls = <RecordedRequest>[];
  final refreshCalls = <RecordedRequest>[];
  final storage = _MemoryTokenStorage(
    accessToken: 'old-access',
    refreshToken: 'old-refresh',
  );
  final refreshDio = recordingDio(
    baseUrl: _baseUrl,
    calls: refreshCalls,
    body: {
      'status': true,
      'code': 200,
      'message': 'Token refreshed',
      'data': {'token': 'new-access', 'refreshToken': 'new-refresh'},
    },
  );
  final session = AuthSessionNotifier();
  var expired = 0;
  session.addListener(() => expired++);
  final api = _api(
    storage: storage,
    refreshDio: refreshDio,
    session: session,
    apiCalls: apiCalls,
    respond: (options) {
      final authorization = options.headers['Authorization'];
      if (authorization == 'Bearer new-access') {
        return _jsonBody(retryStatus, {'message': 'retry failed'});
      }
      return _jsonBody(401, {'message': 'unauthorized'});
    },
  );

  late DioException error;
  try {
    await api.get<void>('/api/orders/drivers/available-orders');
  } on DioException catch (caught) {
    error = caught;
  }
  return _RefreshResult(
    error: error,
    apiCalls: apiCalls,
    refreshCalls: refreshCalls,
    storage: storage,
    expired: expired,
  );
}

Dio _api({
  required _MemoryTokenStorage storage,
  required Dio refreshDio,
  required AuthSessionNotifier session,
  required List<RecordedRequest> apiCalls,
  required ResponseBody Function(RequestOptions options) respond,
}) {
  final api = Dio(BaseOptions(baseUrl: _baseUrl));
  api.httpClientAdapter = _StatusAdapter((options) {
    apiCalls.add(RecordedRequest(options));
    return respond(options);
  });
  final interceptors = AuthInterceptors(
    storage,
    ApiTokenRefresher.testing(dio: refreshDio, baseUrl: () => _baseUrl),
    session,
  );
  api.interceptors.add(interceptors);
  interceptors.attachDio(api);
  return api;
}

class _RefreshResult {
  _RefreshResult({
    required this.error,
    required this.apiCalls,
    required this.refreshCalls,
    required this.storage,
    required this.expired,
  });

  final DioException error;
  final List<RecordedRequest> apiCalls;
  final List<RecordedRequest> refreshCalls;
  final _MemoryTokenStorage storage;
  final int expired;
}

class _ThrowingAdapter implements HttpClientAdapter {
  _ThrowingAdapter(this.error);

  final DioException error;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return Future.error(error);
  }
}

class _StatusAdapter implements HttpClientAdapter {
  _StatusAdapter(this._respond);

  final ResponseBody Function(RequestOptions options) _respond;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _respond(options);
  }
}

ResponseBody _jsonBody(int statusCode, Object body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

class _MemoryTokenStorage implements TokenStorage {
  _MemoryTokenStorage({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;

  @override
  Future<void> clearTokens() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> saveAccessToken(String accessToken) async {
    this.accessToken = accessToken;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
