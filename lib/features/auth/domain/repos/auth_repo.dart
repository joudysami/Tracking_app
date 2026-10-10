import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<ApplyResultEntity>> apply(ApplyParams entity);

  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes();
}
