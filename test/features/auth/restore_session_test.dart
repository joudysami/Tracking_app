import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/network/token_refresh.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login_response.dart';
import 'package:tracking_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/use_case/restore_session_use_case.dart';

import '../../support/jwt.dart';
import '../../support/memory_token_storage.dart';

void main() {
  late MemoryTokenStorage storage;
  late _Refresher refresher;
  late RestoreSessionUseCase restore;

  setUp(() {
    storage = MemoryTokenStorage();
    refresher = _Refresher();
    restore = RestoreSessionUseCase(
      AuthRepositoryImpl(_Remote(), SafeCall(), storage, refresher),
    );
  });

  test('missing session opens login', () async {
    expect(await restore(), AppRoutes.login);
  });

  test('valid session restores without refresh', () async {
    _store(storage, role: 'CUSTOMER', exp: _future);
    expect(await restore(), AppRoutes.home);
    expect(refresher.calls, 0);
  });

  test('expired access token is refreshed', () async {
    _store(storage, role: 'DRIVER', exp: _past);
    refresher.tokens = AuthTokens(
      accessToken: testJwt(role: 'DRIVER', exp: _future),
      refreshToken: 'next-refresh',
    );

    expect(await restore(), AppRoutes.home);
    expect(storage.access, contains('.'));
    expect(storage.refresh, 'next-refresh');
    expect(refresher.calls, 1);
  });

  test('invalid refresh opens login and clears tokens', () async {
    _store(storage, role: 'CUSTOMER', exp: _past);
    refresher.error = DioException(
      requestOptions: RequestOptions(path: '/api/identity/auth/refresh-token'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(),
        statusCode: 401,
        data: {'message': 'Invalid refresh token.'},
      ),
    );

    expect(await restore(), AppRoutes.login);
    expect(storage.access, isNull);
    expect(storage.refresh, isNull);
  });

  test('network failure during refresh keeps the saved route', () async {
    _store(storage, role: 'CUSTOMER', exp: _past, status: 'PendingReview');
    refresher.error = DioException(
      requestOptions: RequestOptions(path: '/api/identity/auth/refresh-token'),
      type: DioExceptionType.connectionTimeout,
    );

    expect(await restore(), AppRoutes.apply);
    expect(storage.refresh, 'refresh-token');
  });
}

void _store(
  MemoryTokenStorage storage, {
  required String role,
  required int exp,
  String? status,
}) {
  storage.access = testJwt(role: role, exp: exp);
  storage.refresh = 'refresh-token';
  storage.expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
  storage.session = StoredSession(role: role, driverApplicationStatus: status);
}

const _future = 4102444800;
const _past = 1600000000;

class _Remote implements AuthRemoteDataSource {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    throw UnimplementedError();
  }
}

class _Refresher implements TokenRefresher {
  AuthTokens? tokens;
  Exception? error;
  int calls = 0;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    calls++;
    final failure = error;
    if (failure != null) throw failure;
    return tokens;
  }
}
