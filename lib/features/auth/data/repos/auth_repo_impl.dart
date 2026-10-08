import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/api_exception.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

import '../data_sources/auth_remote_data_source.dart';
import '../mapper/forget_password_mapper.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final SafeCall safeCall;

  AuthRepoImpl({required this.remoteDataSource, required this.safeCall});

  @override
  Future<BaseResponse<void>> forgetPassword({
    required ForgetPasswordRequest forgetPasswordRequest,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.forgetPassword(
        forgetPasswordRequest.toDto(),
      );
      _checkStatus(
        response.status,
        response.code,
        response.message,
        response.errors,
      );
    });
  }

  @override
  Future<BaseResponse<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.verifyOtp(
        verifyOtpRequest.toDto(),
      );
      _checkStatus(
        response.status,
        response.code,
        response.message,
        response.errors,
      );

      final data = response.data;
      if (data == null) throw ApiException(message: _defaultError);
      return data.toEntity();
    });
  }

  @override
  Future<BaseResponse<void>> resetPassword({
    required ResetPasswordRequest resetPasswordRequest,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.resetPassword(
        resetPasswordRequest.toDto(),
      );
      _checkStatus(
        response.status,
        response.code,
        response.message,
        response.errors,
      );
    });
  }

  static const _defaultError = 'Something went wrong.';

  void _checkStatus(
      bool? status,
      int? code,
      String? message,
      dynamic errors,
      ) {
    if (status == true) return;
    throw ApiException(
      message: message ?? _defaultError,
      statusCode: code,
      errors: errors is Map<String, dynamic> ? errors : null,
    );
  }
}