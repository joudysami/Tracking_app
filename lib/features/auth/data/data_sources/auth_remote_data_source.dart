import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<ApplyResponse> apply(ApplyRequestModel applyrequestmodel);

  Future<VehicleTypesResponse> getVehicleTypes();
}
