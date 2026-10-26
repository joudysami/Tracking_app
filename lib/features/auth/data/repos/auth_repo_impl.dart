import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/error/api_exception.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

import '../mapper/forget_password_mapper.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final SafeCall safeCall;
    final TokenStorage tokenStorage;

  AuthRepoImpl({required this.remoteDataSource, required this.safeCall, required this.tokenStorage});

  @override
  Future<BaseResponse<ApplyResultEntity>> apply(
    ApplyParams entity,
  ) async {
    final request = await ApplyRequestModel.fromEntity(entity);

    final response = await safeCall.safeApiCall(
      () => remoteDataSource.apply(request),
    );

    switch (response) {
      case SuccessResponse<ApplyResponse> success:
        final data = success.data;

        if (data == null) {
          return ErrorResponse<ApplyResultEntity>(
            appError: BadResponseError(
              'The application response is empty.',
            ),
          );
        }

        if (data.status == false) {
          return ErrorResponse<ApplyResultEntity>(
            appError: BadResponseError(
              data.message ?? 'Something went wrong.',
            ),
          );
        }

        final result = data.data;

        if (result == null) {
          return ErrorResponse<ApplyResultEntity>(
            appError: BadResponseError(
              'The application data is empty.',
            ),
          );
        }

        return SuccessResponse<ApplyResultEntity>(
          result.toDomain(),
        );

      case ErrorResponse<ApplyResponse> error:
        return ErrorResponse<ApplyResultEntity>(
          appError: error.appError,
        );
    }
  }

  @override
  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes() async {
    final response = await safeCall.safeApiCall(
      remoteDataSource.getVehicleTypes,
    );

    switch (response) {
      case SuccessResponse<VehicleTypesResponse> success:
        final data = success.data;

        if (data == null) {
          return ErrorResponse<List<VehicleTypeEntity>>(
            appError: BadResponseError(
              'The vehicle types response is empty.',
            ),
          );
        }

        if (data.status == false) {
          return ErrorResponse<List<VehicleTypeEntity>>(
            appError: BadResponseError(
              data.message ?? 'Something went wrong.',
            ),
          );
        }

        final entities = (data.data ?? [])
            .map((vehicleType) => vehicleType.toDomain())
            .toList();

        return SuccessResponse<List<VehicleTypeEntity>>(
          entities,
        );

      case ErrorResponse<VehicleTypesResponse> error:
        return ErrorResponse<List<VehicleTypeEntity>>(
          appError: error.appError,
        );
    }
  }


 @override
  Future<BaseResponse<LoginEntity>> signIn(LoginRequest request) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.login(request);

      await tokenStorage.saveTokens(
        accessToken: response.data.accessToken,
        refreshToken: response.data.refreshToken,
      );

      return response.data.toDomain();
    });
  }


  @override
  Future<void> signOut() {
    return tokenStorage.clearTokens();
  }
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

      if (data == null) {
        throw ApiException(message: _defaultError);
      }

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
