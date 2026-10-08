import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';

import '../../../../core/base/base_response.dart';

abstract interface class AuthRepo {

  Future<BaseResponse<void>> forgetPassword({
    required ForgetPasswordRequest forgetPasswordRequest,
  });

  Future<BaseResponse<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  });

  Future<BaseResponse<void>> resetPassword({
    required ResetPasswordRequest resetPasswordRequest,
  });
}