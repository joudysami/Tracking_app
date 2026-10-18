import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/reset_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login/login_response.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';
import 'package:tracking_app/features/auth/data/repos/auth_repo_impl.dart';

void main() {
  test('a failed login envelope does not persist tokens', () async {
    final storage = _MemoryTokenStorage();
    final repo = AuthRepoImpl(
      remoteDataSource: _LoginSource(
        LoginResponse.fromJson({
          'status': false,
          'code': 200,
          'message': 'Invalid credentials',
          'data': null,
        }),
      ),
      safeCall: SafeCall(),
      tokenStorage: storage,
    );

    final result = await repo.signIn(
      LoginRequest(email: 'driver@example.com', password: 'Password1'),
    );

    expect(result, isA<ErrorResponse>());
    expect((result as ErrorResponse).errorMessage, 'Invalid credentials');
    expect(storage.saved, isFalse);
    expect(storage.accessToken, isNull);
    expect(storage.refreshToken, isNull);
  });

  test('malformed token data does not persist tokens', () async {
    final storage = _MemoryTokenStorage();
    final repo = AuthRepoImpl(
      remoteDataSource: _LoginSource(
        LoginResponse.fromJson({
          'status': true,
          'code': 200,
          'message': 'Logged in',
          'data': {'token': '', 'refreshToken': 'refresh-token'},
        }),
      ),
      safeCall: SafeCall(),
      tokenStorage: storage,
    );

    final result = await repo.signIn(
      LoginRequest(email: 'driver@example.com', password: 'Password1'),
    );

    expect(result, isA<ErrorResponse>());
    expect(storage.saved, isFalse);
  });

  test('a successful login persists both tokens', () async {
    final storage = _MemoryTokenStorage();
    final repo = AuthRepoImpl(
      remoteDataSource: _LoginSource(
        LoginResponse.fromJson({
          'status': true,
          'code': 200,
          'message': 'Logged in',
          'data': {
            'token': 'access-token',
            'refreshToken': 'refresh-token',
            'user': {
              'roles': ['DRIVER'],
            },
          },
        }),
      ),
      safeCall: SafeCall(),
      tokenStorage: storage,
    );

    final result = await repo.signIn(
      LoginRequest(email: 'driver@example.com', password: 'Password1'),
    );

    expect(result, isA<SuccessResponse>());
    expect(storage.accessToken, 'access-token');
    expect(storage.refreshToken, 'refresh-token');
  });
}

class _LoginSource implements AuthRemoteDataSource {
  _LoginSource(this.response);

  final LoginResponse response;

  @override
  Future<LoginResponse> login(LoginRequest request) async => response;

  @override
  Future<ApplyResponse> apply(ApplyRequestModel applyrequestmodel) {
    throw UnimplementedError();
  }

  @override
  Future<ForgetPasswordResponseDto> forgetPassword(
    ForgetPasswordRequestDto forgetPasswordRequest,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<VehicleTypesResponse> getVehicleTypes() {
    throw UnimplementedError();
  }

  @override
  Future<ForgetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto resetPasswordRequest,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<VerifyOtpResponseDto> verifyOtp(VerifyOtpRequestDto verifyOtpRequest) {
    throw UnimplementedError();
  }
}

class _MemoryTokenStorage implements TokenStorage {
  String? accessToken;
  String? refreshToken;
  bool saved = false;

  @override
  Future<void> clearTokens() async {}

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> saveAccessToken(String accessToken) async {
    saved = true;
    this.accessToken = accessToken;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    saved = true;
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
