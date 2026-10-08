// test/features/auth/domain/use_cases/auth_use_cases_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/verify_otp_use_case.dart';

import 'forget_password_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepo>()])
void main() {
  late MockAuthRepo repo;

  setUpAll(() {
    provideDummy<BaseResponse<void>>(const SuccessResponse<void>(null));
    provideDummy<BaseResponse<VerifyOtpResponse>>(
      const SuccessResponse<VerifyOtpResponse>(null),
    );
  });

  setUp(() => repo = MockAuthRepo());

  group('ForgetPasswordUseCase', () {
    const request = ForgetPasswordRequest(email: 'a@b.com');

    test('delegates to the repo and returns its success', () async {
      const response = SuccessResponse<void>(null);
      when(repo.forgetPassword(forgetPasswordRequest: request))
          .thenAnswer((_) async => response);

      final result = await ForgetPasswordUseCase(repo)(request: request);

      expect(result, same(response));
      verify(repo.forgetPassword(forgetPasswordRequest: request)).called(1);
      verifyNoMoreInteractions(repo);
    });

    test('returns the repo error unchanged', () async {
      final response =
      ErrorResponse<void>(appError: BadResponseError('Invalid email'));
      when(repo.forgetPassword(forgetPasswordRequest: request))
          .thenAnswer((_) async => response);

      final result = await ForgetPasswordUseCase(repo)(request: request);

      expect(result, same(response));
    });
  });

  group('VerifyOtpUseCase', () {
    const request = VerifyOtpRequest(email: 'a@b.com', otp: '123456');

    test('delegates to the repo and returns its data', () async {
      const response = SuccessResponse<VerifyOtpResponse>(
        VerifyOtpResponse(otpToken: 'token-1', expiresInMinutes: 30),
      );
      when(repo.verifyOtp(verifyOtpRequest: request))
          .thenAnswer((_) async => response);

      final result = await VerifyOtpUseCase(repo)(request: request);

      expect(result, same(response));
      verify(repo.verifyOtp(verifyOtpRequest: request)).called(1);
      verifyNoMoreInteractions(repo);
    });

    test('returns the repo error unchanged', () async {
      final response = ErrorResponse<VerifyOtpResponse>(
        appError: BadResponseError('Invalid OTP'),
      );
      when(repo.verifyOtp(verifyOtpRequest: request))
          .thenAnswer((_) async => response);

      final result = await VerifyOtpUseCase(repo)(request: request);

      expect(result, same(response));
    });
  });

  group('ResetPasswordUseCase', () {
    const request = ResetPasswordRequest(
      otpToken: 'token-1',
      password: 'Abcdef1',
      confirmPassword: 'Abcdef1',
    );

    test('delegates to the repo and returns its success', () async {
      const response = SuccessResponse<void>(null);
      when(repo.resetPassword(resetPasswordRequest: request))
          .thenAnswer((_) async => response);

      final result = await ResetPasswordUseCase(repo)(request: request);

      expect(result, same(response));
      verify(repo.resetPassword(resetPasswordRequest: request)).called(1);
      verifyNoMoreInteractions(repo);
    });

    test('returns the repo error unchanged', () async {
      final response =
      ErrorResponse<void>(appError: BadResponseError('Token expired'));
      when(repo.resetPassword(resetPasswordRequest: request))
          .thenAnswer((_) async => response);

      final result = await ResetPasswordUseCase(repo)(request: request);

      expect(result, same(response));
    });
  });
}