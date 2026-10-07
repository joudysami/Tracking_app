import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/jwt_payload.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/network/token_refresh.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';
import 'package:tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/session_invalid_exception.dart';

@Injectable(as: AuthRepo)
class AuthRepositoryImpl implements AuthRepo {
  AuthRepositoryImpl(
    this._remote,
    this._safeCall,
    this._tokenStorage,
    this._tokenRefresher,
  );

  final AuthRemoteDataSource _remote;
  final SafeCall _safeCall;
  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;

  @override
  Future<BaseResponse<AuthSession>> signIn(LoginRequest request) {
    return _safeCall.safeApiCall(() => _signIn(request));
  }

  Future<AuthSession> _signIn(LoginRequest request) async {
    final response = await _remote.login(request);
    final data = response.data;
    if (data == null) {
      throw StateError(
        response.message ?? 'Login response did not contain data',
      );
    }
    final session = data.toSession();
    await _tokenStorage.saveSession(
      accessToken: data.token,
      refreshToken: data.refreshToken,
      role: session.role,
      driverApplicationStatus: session.driverApplicationStatus,
      canAccessDriverHome: session.canAccessDriverHome,
    );
    return session;
  }

  @override
  Future<AuthSession?> currentSession() async {
    final stored = await _tokenStorage.readSession();
    if (stored != null) return _fromStored(stored);
    final access = await _tokenStorage.getAccessToken();
    final refresh = await _tokenStorage.getRefreshToken();
    if (_blank(access) && _blank(refresh)) return null;
    final role = jwtRole(access);
    if (role == null || role.isEmpty) return _refreshOnlySession(refresh);
    return AuthSession(role: role);
  }

  @override
  Future<bool> accessTokenExpired() async {
    final access = await _tokenStorage.getAccessToken();
    if (_blank(access)) return true;
    final expiry =
        await _tokenStorage.getAccessTokenExpiry() ?? jwtExpiry(access);
    if (expiry == null) return false;
    return !expiry.isAfter(DateTime.now().toUtc());
  }

  @override
  Future<AuthSession> refreshSession() async {
    final refresh = await _tokenStorage.getRefreshToken();
    if (_blank(refresh)) return _reject();
    try {
      return await _refresh(refresh!);
    } on DioException catch (error) {
      if (_refreshRejected(error)) return _reject();
      rethrow;
    }
  }

  Future<AuthSession> _refresh(String refresh) async {
    final tokens = await _tokenRefresher.refresh(refresh);
    if (tokens == null) return _reject();
    await _tokenStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken ?? refresh,
    );
    return _requiredSession();
  }

  Future<AuthSession> _requiredSession() async {
    final session = await currentSession();
    if (session == null || session.role.isEmpty) return _reject();
    return session;
  }

  Future<AuthSession> _reject() async {
    await _tokenStorage.clearTokens();
    throw const SessionInvalidException();
  }
}

AuthSession _fromStored(StoredSession stored) {
  return AuthSession(
    role: stored.role,
    driverApplicationStatus: stored.driverApplicationStatus,
    canAccessDriverHome: stored.canAccessDriverHome,
  );
}

AuthSession? _refreshOnlySession(String? refresh) {
  if (_blank(refresh)) return null;
  return const AuthSession(role: '');
}

bool _blank(String? value) => value == null || value.isEmpty;

bool _refreshRejected(DioException error) {
  final status = error.response?.statusCode;
  return status == 400 || status == 401;
}
