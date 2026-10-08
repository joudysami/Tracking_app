import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final SafeCall safeCall;

  AuthRepoImpl({required this.remoteDataSource, required this.safeCall});

  @override
  Future<BaseResponse<ApplyResultEntity>> apply(
    ApplyRequestModel request,
  ) async {
    final response = await safeCall.safeApiCall(
      () => remoteDataSource.apply(request),
    );

    switch (response) {
      case SuccessResponse<ApplyResponse> success:
        final data = success.data;
        if (data == null) {
          return ErrorResponse<ApplyResultEntity>(
            appError: BadResponseError('The application response is empty.'),
          );
        }

        final result = data.data;
        if (result == null) {
          return ErrorResponse<ApplyResultEntity>(
            appError: BadResponseError('The application data is empty.'),
          );
        }

        return SuccessResponse<ApplyResultEntity>(result.toDomain());

      case ErrorResponse<ApplyResponse> error:
        return ErrorResponse<ApplyResultEntity>(appError: error.appError);
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
            appError: BadResponseError('The vehicle types response is empty.'),
          );
        }

        final entities = (data.data ?? [])
            .map((vehicleType) => vehicleType.toDomain())
            .toList();

        return SuccessResponse<List<VehicleTypeEntity>>(entities);

      case ErrorResponse<VehicleTypesResponse> error:
        return ErrorResponse<List<VehicleTypeEntity>>(
          appError: error.appError,
        );
    }
  }
}
