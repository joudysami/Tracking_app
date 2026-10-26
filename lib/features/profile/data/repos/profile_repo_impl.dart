import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/features/profile/data/models/operation_response.dart';
import 'package:tracking_app/features/profile/data/models/profile_form_requests.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/repos/profile_repo.dart';

const _emptyResponse = 'The profile response is empty.';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl({
    required this.remote,
    required this.safeCall,
    required this.tokenStorage,
  });

  final ProfileRemoteDataSource remote;
  final SafeCall safeCall;
  final TokenStorage tokenStorage;

  @override
  Future<BaseResponse<UserProfileEntity>> getProfile() async {
    final response = await safeCall.safeApiCall(remote.getProfile);
    return _profileResult(response);
  }

  @override
  Future<BaseResponse<UserProfileEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    final request = await UpdateProfileRequest.fromParams(params);
    final response = await safeCall.safeApiCall(
      () => remote.updateProfile(request),
    );
    return _profileResult(response);
  }

  @override
  Future<BaseResponse<VehicleInfoEntity>> getVehicleInfo() async {
    final response = await safeCall.safeApiCall(remote.getVehicle);
    return _vehicleResult(response);
  }

  @override
  Future<BaseResponse<VehicleInfoEntity>> updateVehicle(
    UpdateVehicleParams params,
  ) async {
    final request = await UpdateVehicleRequest.fromParams(params);
    final response = await safeCall.safeApiCall(
      () => remote.updateVehicle(request),
    );
    return _vehicleResult(response);
  }

  @override
  Future<BaseResponse<void>> changePassword(ChangePasswordParams params) async {
    final request = ChangePasswordRequestDto.fromParams(params);
    final response = await safeCall.safeApiCall(
      () => remote.changePassword(request),
    );
    return _passwordResult(response);
  }

  @override
  Future<BaseResponse<void>> logout() async {
    await _revokeRemoteSession();
    await tokenStorage.clearTokens();
    return const SuccessResponse(null);
  }

  Future<void> _revokeRemoteSession() async {
    final refresh = await tokenStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return;
    await safeCall.safeApiCall(() => remote.logout(refresh));
  }

  Future<BaseResponse<void>> _passwordResult(
    BaseResponse<OperationResponse> response,
  ) async {
    final mapped = _voidResult(response);
    if (mapped is! SuccessResponse<void>) return mapped;
    await tokenStorage.clearTokens();
    return mapped;
  }
}

BaseResponse<UserProfileEntity> _profileResult(
  BaseResponse<UserProfileResponse> response,
) {
  return switch (response) {
    SuccessResponse(:final data) => _profileData(data),
    ErrorResponse(:final appError) => ErrorResponse(appError: appError),
  };
}

BaseResponse<UserProfileEntity> _profileData(UserProfileResponse? response) {
  final dto = response?.data;
  if (response == null || !response.success || dto == null) {
    return _failure(response?.message);
  }
  return SuccessResponse(dto.toEntity());
}

BaseResponse<VehicleInfoEntity> _vehicleResult(
  BaseResponse<DriverProfileResponse> response,
) {
  return switch (response) {
    SuccessResponse(:final data) => _vehicleData(data),
    ErrorResponse(:final appError) => ErrorResponse(appError: appError),
  };
}

BaseResponse<VehicleInfoEntity> _vehicleData(DriverProfileResponse? response) {
  final dto = response?.data;
  if (response == null || !response.success || dto == null) {
    return _failure(response?.message);
  }
  return SuccessResponse(dto.toEntity());
}

BaseResponse<void> _voidResult(BaseResponse<OperationResponse> response) {
  return switch (response) {
    SuccessResponse(:final data) => _operation(data),
    ErrorResponse(:final appError) => ErrorResponse(appError: appError),
  };
}

BaseResponse<void> _operation(OperationResponse? response) {
  if (response == null || !response.success) return _failure(response?.message);
  return const SuccessResponse(null);
}

ErrorResponse<T> _failure<T>(String? message) {
  return ErrorResponse(appError: BadResponseError(message ?? _emptyResponse));
}
