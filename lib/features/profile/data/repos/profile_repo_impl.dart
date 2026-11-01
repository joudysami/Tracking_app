import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/operation_response.dart';
import 'package:tracking_app/features/profile/data/models/profile_form_requests.dart';
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
    return _mapEnvelope(
      response,
      isSuccess: (body) => body.success,
      messageOf: (body) => body.message,
      read: (body) => body.data?.toEntity(),
    );
  }

  @override
  Future<BaseResponse<UserProfileEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    final request = await UpdateProfileRequest.fromParams(params);
    final response = await safeCall.safeApiCall(
      () => remote.updateProfile(request),
    );
    return _mapEnvelope(
      response,
      isSuccess: (body) => body.success,
      messageOf: (body) => body.message,
      read: (body) => body.data?.toEntity(),
    );
  }

  @override
  Future<BaseResponse<VehicleInfoEntity>> getVehicleInfo() async {
    final response = await safeCall.safeApiCall(remote.getVehicle);
    return _mapEnvelope(
      response,
      isSuccess: (body) => body.success,
      messageOf: (body) => body.message,
      read: (body) => body.data?.toEntity(),
    );
  }

  @override
  Future<BaseResponse<VehicleInfoEntity>> updateVehicle(
    UpdateVehicleParams params,
  ) async {
    final request = await UpdateVehicleRequest.fromParams(params);
    final response = await safeCall.safeApiCall(
      () => remote.updateVehicle(request),
    );
    return _mapEnvelope(
      response,
      isSuccess: (body) => body.success,
      messageOf: (body) => body.message,
      read: (body) => body.data?.toEntity(),
    );
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
    final mapped = _mapEnvelope<OperationResponse, void>(
      response,
      isSuccess: (body) => body.success,
      messageOf: (body) => body.message,
    );
    if (mapped is! SuccessResponse<void>) return mapped;
    await tokenStorage.clearTokens();
    return mapped;
  }
}

BaseResponse<R> _mapEnvelope<T, R>(
  BaseResponse<T> response, {
  required bool Function(T body) isSuccess,
  required String? Function(T body) messageOf,
  R? Function(T body)? read,
}) {
  return switch (response) {
    ErrorResponse(:final appError) => ErrorResponse(appError: appError),
    SuccessResponse(:final data) => _readEnvelope(
      data,
      isSuccess: isSuccess,
      messageOf: messageOf,
      read: read,
    ),
  };
}

BaseResponse<R> _readEnvelope<T, R>(
  T? body, {
  required bool Function(T body) isSuccess,
  required String? Function(T body) messageOf,
  required R? Function(T body)? read,
}) {
  if (body == null) return _failure();
  if (!isSuccess(body)) return _failure(messageOf(body));
  if (read == null) return SuccessResponse<R>(null);
  final value = read(body);
  if (value == null) return _failure();
  return SuccessResponse(value);
}

ErrorResponse<T> _failure<T>([String? message]) {
  final text = message?.trim();
  final resolved = text == null || text.isEmpty ? _emptyResponse : text;
  return ErrorResponse(appError: BadResponseError(resolved));
}
