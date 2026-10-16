import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/reset_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login/login_response.dart';

abstract interface class AuthRemoteDataSource {
    Future<LoginResponse> login(LoginRequest request);
  Future<ForgetPasswordResponseDto> forgetPassword(
    ForgetPasswordRequestDto forgetPasswordRequest,
  );
  Future<ForgetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto resetPasswordRequest,
  );
  Future<VerifyOtpResponseDto> verifyOtp(VerifyOtpRequestDto verifyOtpRequest);
   Future<ApplyResponse> apply(ApplyRequestModel applyrequestmodel);

  Future<VehicleTypesResponse> getVehicleTypes();
}
