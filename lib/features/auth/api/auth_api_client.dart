import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/constant/api_request_params.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

 @MultiPart()
  @POST(ApiEndpoints.applyDriver)
  Future<ApplyResponse> apply(
    @Part(name: ApiRequestParams.vehicleTypeId) String vehicleTypeId,
    @Part(name: ApiRequestParams.firstName) String firstName,
    @Part(name: ApiRequestParams.lastName) String lastName,
    @Part(name: ApiRequestParams.gender) int gender,
    @Part(name: ApiRequestParams.vehicleCapacity) int vehicleCapacity,
    @Part(name: ApiRequestParams.fcmToken) String fcmToken,
    @Part(name: ApiRequestParams.nid) String nid,
    @Part(name: ApiRequestParams.phone) String phone,
    @Part(name: ApiRequestParams.vehiclePlateNumber) String vehiclePlateNumber,
    @Part(name: ApiRequestParams.email) String email,
    @Part(name: ApiRequestParams.password) String password,
    @Part(name: ApiRequestParams.confirmPassword) String confirmPassword,
    @Part(name: ApiRequestParams.licenceImage) MultipartFile licenceImage,
    @Part(name: ApiRequestParams.nidImage) MultipartFile nidImage,
  );
  @GET(ApiEndpoints.vehicleTypes)
  Future<VehicleTypesResponse> getVehicleTypes();
  
}
