import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';

import '../../api/auth_api_client.dart';
import 'auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ApplyResponse> apply(ApplyRequestModel applyRequestModel) {
    return apiClient.apply(
      applyRequestModel.vehicleTypeId,
      applyRequestModel.firstName,
      applyRequestModel.lastName,
      applyRequestModel.gender,
      applyRequestModel.vehicleCapacity,
      applyRequestModel.fcmToken,
      applyRequestModel.nid,
      applyRequestModel.phone,
      applyRequestModel.vehiclePlateNumber,
      applyRequestModel.email,
      applyRequestModel.password,
      applyRequestModel.confirmPassword,
      applyRequestModel.licenceImage,
      applyRequestModel.nidImage,
    );
  }

  @override
  Future<VehicleTypesResponse> getVehicleTypes() {
    return apiClient.getVehicleTypes();
  }
}
