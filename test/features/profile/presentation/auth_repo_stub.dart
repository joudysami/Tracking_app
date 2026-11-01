import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

class UnusedAuthRepo implements AuthRepo {
  @override
  Future<BaseResponse<ApplyResultEntity>> apply(ApplyParams entity) =>
      _unused();

  @override
  Future<BaseResponse<void>> forgetPassword({
    required ForgetPasswordRequest forgetPasswordRequest,
  }) {
    return _unused();
  }

  @override
  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes() => _unused();

  @override
  Future<BaseResponse<LoginEntity>> signIn(LoginRequest request) => _unused();

  @override
  Future<void> signOut() => _unused();

  @override
  Future<BaseResponse<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) {
    return _unused();
  }

  @override
  Future<BaseResponse<void>> resetPassword({
    required ResetPasswordRequest resetPasswordRequest,
  }) {
    return _unused();
  }
}

Future<T> _unused<T>() => throw UnimplementedError();
