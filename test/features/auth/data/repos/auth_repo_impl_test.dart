import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/reset_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRemoteDataSource>()])
void main() {
  late MockAuthRemoteDataSource remote;
  late AuthRepoImpl repo;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    repo = AuthRepoImpl(remoteDataSource: remote, safeCall: SafeCall());
  });

  AppError errorOf(BaseResponse response) =>
      (response as ErrorResponse).appError;

  ForgetPasswordResponseDto okResponse() => ForgetPasswordResponseDto(
    status: true,
    code: 200,
    message: 'success',
    data: true,
  );

  ForgetPasswordResponseDto failedResponse({dynamic errors}) =>
      ForgetPasswordResponseDto(
        status: false,
        code: 400,
        message: 'Invalid email',
        errors: errors,
      );

  DioException dioError(DioExceptionType type) => DioException(
    requestOptions: RequestOptions(path: '/'),
    type: type,
  );

  group('forgetPassword', () {
    const request = ForgetPasswordRequest(email: 'a@b.com');

    test('returns SuccessResponse and maps the request to a DTO', () async {
      when(remote.forgetPassword(any)).thenAnswer((_) async => okResponse());

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(result, isA<SuccessResponse>());
      final sent = verify(remote.forgetPassword(captureAny)).captured.single
      as ForgetPasswordRequestDto;
      expect(sent.email, 'a@b.com');
    });

    test('returns BadResponseError with the server message when status is false',
            () async {
          when(remote.forgetPassword(any))
              .thenAnswer((_) async => failedResponse());

          final result = await repo.forgetPassword(forgetPasswordRequest: request);

          expect(result, isA<ErrorResponse>());
          expect(errorOf(result), isA<BadResponseError>());
          expect(errorOf(result).message, 'Invalid email');
        });

    test('uses the field errors as the message when the server sends them',
            () async {
          when(remote.forgetPassword(any)).thenAnswer(
                (_) async => failedResponse(errors: {
              'email': ['Not found'],
            }),
          );

          final result = await repo.forgetPassword(forgetPasswordRequest: request);

          expect(errorOf(result).message, 'Not found');
        });

    test('falls back to the default message when message is null', () async {
      when(remote.forgetPassword(any)).thenAnswer(
            (_) async => ForgetPasswordResponseDto(status: false),
      );

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(errorOf(result).message, 'Something went wrong.');
    });

    test('treats a null status as a failure', () async {
      when(remote.forgetPassword(any)).thenAnswer(
            (_) async => ForgetPasswordResponseDto(message: 'no status'),
      );

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(result, isA<ErrorResponse>());
    });

    test('maps a timeout DioException to TimeOutError', () async {
      when(remote.forgetPassword(any)).thenAnswer(
            (_) async => throw dioError(DioExceptionType.connectionTimeout),
      );

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(errorOf(result), isA<TimeOutError>());
    });
  });

  group('verifyOtp', () {
    const request = VerifyOtpRequest(email: 'a@b.com', otp: '123456');

    test('returns the entity mapped from the data DTO', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => VerifyOtpResponseDto(
          status: true,
          code: 200,
          message: 'OTP verified',
          data: VerifyOtpDataDto(otpToken: 'token-1', expiresInMinutes: 30),
        ),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(result, isA<SuccessResponse<VerifyOtpResponse>>());
      expect(
        (result as SuccessResponse<VerifyOtpResponse>).data,
        const VerifyOtpResponse(otpToken: 'token-1', expiresInMinutes: 30),
      );
      final sent = verify(remote.verifyOtp(captureAny)).captured.single
      as VerifyOtpRequestDto;
      expect(sent.email, 'a@b.com');
      expect(sent.otp, '123456');
    });

    test('returns an error when status is true but data is null', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => VerifyOtpResponseDto(status: true, code: 200),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(result, isA<ErrorResponse>());
      expect(errorOf(result).message, 'Something went wrong.');
    });

    test('returns the server message when the code is wrong', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => VerifyOtpResponseDto(
          status: false,
          code: 400,
          message: 'Invalid OTP',
        ),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(errorOf(result), isA<BadResponseError>());
      expect(errorOf(result).message, 'Invalid OTP');
    });

    test('maps a connection error to NoInternetError', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => throw DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionError,
          message: 'offline',
        ),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(errorOf(result), isA<NoInternetError>());
    });
  });

  group('resetPassword', () {
    const request = ResetPasswordRequest(
      otpToken: 'token-1',
      password: 'Abcdef1',
      confirmPassword: 'Abcdef1',
    );

    test('returns SuccessResponse and maps the request to a DTO', () async {
      when(remote.resetPassword(any)).thenAnswer((_) async => okResponse());

      final result = await repo.resetPassword(resetPasswordRequest: request);

      expect(result, isA<SuccessResponse>());
      final sent = verify(remote.resetPassword(captureAny)).captured.single
      as ResetPasswordRequestDto;
      expect(sent.otpToken, 'token-1');
      expect(sent.password, 'Abcdef1');
      expect(sent.confirmPassword, 'Abcdef1');
    });

    test('returns BadResponseError when status is false', () async {
      when(remote.resetPassword(any)).thenAnswer(
            (_) async => failedResponse(),
      );

      final result = await repo.resetPassword(resetPasswordRequest: request);

      expect(errorOf(result), isA<BadResponseError>());
      expect(errorOf(result).message, 'Invalid email');
    });

    test('maps a 401 DioException to UnauthorizedError', () async {
      when(remote.resetPassword(any)).thenAnswer(
            (_) async => throw DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 401,
          ),
        ),
      );

      final result = await repo.resetPassword(resetPasswordRequest: request);

      expect(errorOf(result), isA<UnauthorizedError>());
    });
  });
}