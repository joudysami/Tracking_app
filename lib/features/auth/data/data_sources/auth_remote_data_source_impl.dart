import 'package:dio/dio.dart';
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
  Future<ApplyResponse> apply(ApplyRequestModel applyrequestmodel) async {
    final licenceImage = await MultipartFile.fromFile(
      applyrequestmodel.licenceImagePath,
    );

    final nidImage = await MultipartFile.fromFile(
      applyrequestmodel.nidImagePath,
    );

    return apiClient.apply(
      applyrequestmodel.vehicleTypeId,
      applyrequestmodel.firstName,
      applyrequestmodel.lastName,
      applyrequestmodel.gender,
      applyrequestmodel.vehicleCapacity,
      applyrequestmodel.fcmToken,
      applyrequestmodel.nid,
      applyrequestmodel.phone,
      applyrequestmodel.vehiclePlateNumber,
      applyrequestmodel.email,
      applyrequestmodel.password,
      applyrequestmodel.confirmPassword,
      licenceImage,
      nidImage,
    );
  }

  @override
  Future<VehicleTypesResponse> getVehicleTypes() {
    return apiClient.getVehicleTypes();
  }
}
