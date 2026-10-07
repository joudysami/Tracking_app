import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/reset_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';

extension ForgetPasswordRequestMapper on ForgetPasswordRequest {
  ForgetPasswordRequestDto toDto() => ForgetPasswordRequestDto(email: email);
}

extension ResetPasswordRequestMapper on ResetPasswordRequest {
  ResetPasswordRequestDto toDto() => ResetPasswordRequestDto(
    otpToken: otpToken,
    password: password,
    confirmPassword: confirmPassword,
  );
}

extension VerifyOtpRequestMapper on VerifyOtpRequest {
  VerifyOtpRequestDto toDto() => VerifyOtpRequestDto(email: email, otp: otp);
}

extension VerifyOtpDataDtoMapper on VerifyOtpDataDto {
  VerifyOtpResponse toEntity() => VerifyOtpResponse(
    otpToken: otpToken,
    expiresInMinutes: expiresInMinutes,
  );
}