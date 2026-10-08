import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<ApplyResultEntity>> apply(ApplyRequestModel request);
  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes();
}
