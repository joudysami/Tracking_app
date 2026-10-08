import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/reset_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_response_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<ForgetPasswordResponseDto> forgetPassword(
    ForgetPasswordRequestDto forgetPasswordRequest,
  );
  Future<ForgetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto resetPasswordRequest,
  );
  Future<VerifyOtpResponseDto> verifyOtp(VerifyOtpRequestDto verifyOtpRequest);
}
