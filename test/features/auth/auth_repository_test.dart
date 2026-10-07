import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/network/token_refresh.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login_response.dart';
import 'package:tracking_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/login_failure.dart';
import 'package:tracking_app/features/auth/domain/session_invalid_exception.dart';
import 'package:tracking_app/core/base/base_response.dart';

import '../../support/jwt.dart';
import '../../support/memory_token_storage.dart';

void main() {
  late MemoryTokenStorage storage;
  late _Remote remote;
  late _Refresher refresher;
  late AuthRepositoryImpl repo;

  setUp(() {
    storage = MemoryTokenStorage();
    remote = _Remote();
    refresher = _Refresher();
    repo = AuthRepositoryImpl(remote, SafeCall(), storage, refresher);
  });

  test('stores tokens and role from a successful login', () async {
    remote.response = LoginResponse.fromJson({
      'status': true,
      'message': 'Logged in',
      'data': {
        'token': testJwt(role: 'CUSTOMER', exp: _future),
        'refreshToken': 'refresh-token',
        'user': {
          'roles': ['CUSTOMER'],
        },
      },
    });

    final response = await repo.signIn(
      const LoginRequest(email: 'rider@example.com', password: 'secret'),
    );

    expect(response, isA<SuccessResponse>());
    expect(storage.access, isNotEmpty);
    expect(storage.refresh, 'refresh-token');
    expect(storage.session?.role, 'CUSTOMER');
    expect(remote.request?.email, 'rider@example.com');
  });

  test('maps invalid credentials separately from network failure', () async {
    remote.error = _dio(401, 'Invalid email or password');
    final credential = await repo.signIn(
      const LoginRequest(email: 'a@b.com', password: 'nope'),
    );

    remote.error = DioException(
      requestOptions: RequestOptions(path: '/api/identity/auth/login'),
      type: DioExceptionType.connectionError,
      message: 'Connection refused',
    );
    final network = await repo.signIn(
      const LoginRequest(email: 'a@b.com', password: 'nope'),
    );

    expect(_error(credential), isA<BadResponseError>());
    expect(isCredentialLoginFailure(_error(credential)), isTrue);
    expect(isCredentialLoginFailure(_error(network)), isFalse);
    expect(storage.access, isNull);
  });

  test('clears the session when refresh is rejected', () async {
    storage.refresh = 'old-refresh';
    storage.session = null;
    refresher.error = _dio(401, 'Invalid refresh token.');

    await expectLater(
      repo.refreshSession(),
      throwsA(isA<SessionInvalidException>()),
    );
    expect(storage.refresh, isNull);
  });
}

AppError _error(BaseResponse<dynamic> response) {
  return (response as ErrorResponse).appError;
}

DioException _dio(int status, String message) {
  final options = RequestOptions(path: '/api/identity/auth/login');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: options,
      statusCode: status,
      data: {'status': false, 'code': status, 'message': message},
    ),
  );
}

const _future = 4102444800;

class _Remote implements AuthRemoteDataSource {
  LoginResponse? response;
  Exception? error;
  LoginRequest? request;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    this.request = request;
    final failure = error;
    if (failure != null) throw failure;
    return response!;
  }
}

class _Refresher implements TokenRefresher {
  AuthTokens? tokens;
  Exception? error;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    final failure = error;
    if (failure != null) throw failure;
    return tokens;
  }
}
