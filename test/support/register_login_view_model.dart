import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/di/di.dart';
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
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_viewmodel.dart';

/// The login route resolves [LoginViewModel] from GetIt. Widget tests that
/// open that route do not start the app's dependency graph.
void registerLoginViewModelForTests() {
  if (getIt.isRegistered<LoginViewModel>()) return;
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(LoginUseCase(const _UnusedAuthRepo())),
  );
}

class _UnusedAuthRepo implements AuthRepo {
  const _UnusedAuthRepo();

  @override
  Future<BaseResponse<ApplyResultEntity>> apply(ApplyParams entity) =>
      throw UnimplementedError();

  @override
  Future<BaseResponse<void>> forgetPassword({
    required ForgetPasswordRequest forgetPasswordRequest,
  }) => throw UnimplementedError();

  @override
  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes() =>
      throw UnimplementedError();

  @override
  Future<BaseResponse<void>> resetPassword({
    required ResetPasswordRequest resetPasswordRequest,
  }) => throw UnimplementedError();

  @override
  Future<BaseResponse<LoginEntity>> signIn(LoginRequest request) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();

  @override
  Future<BaseResponse<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) => throw UnimplementedError();
}
