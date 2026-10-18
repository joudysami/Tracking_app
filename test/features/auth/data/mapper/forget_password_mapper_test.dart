// test/features/auth/data/mappers/forget_password_mappers_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/mapper/forget_password_mapper.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
// imports: الـ mappers + الـ DTOs + الـ entities

void main() {
  test('ForgetPasswordRequest -> DTO', () {
    final dto = const ForgetPasswordRequest(email: 'a@b.com').toDto();
    expect(dto.email, 'a@b.com');
  });

  test('VerifyOtpRequest -> DTO', () {
    final dto = const VerifyOtpRequest(email: 'a@b.com', otp: '123456').toDto();
    expect(dto.email, 'a@b.com');
    expect(dto.otp, '123456');
  });

  test('ResetPasswordRequest -> DTO', () {
    final dto = const ResetPasswordRequest(
      otpToken: 'token-1',
      password: 'Abcdef1',
      confirmPassword: 'Abcdef1',
    ).toDto();
    expect(dto.otpToken, 'token-1');
    expect(dto.password, 'Abcdef1');
    expect(dto.confirmPassword, 'Abcdef1');
  });

  test('VerifyOtpDataDto -> entity', () {
    final entity =
    VerifyOtpDataDto(otpToken: 'token-1', expiresInMinutes: 30).toEntity();
    expect(
      entity,
      const VerifyOtpResponse(otpToken: 'token-1', expiresInMinutes: 30),
    );
  });

  test('VerifyOtpDataDto with nulls -> entity with nulls', () {
    final entity = VerifyOtpDataDto().toEntity();
    expect(entity, const VerifyOtpResponse());
  });
}