import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/constant/api_request_params.dart';
import 'package:tracking_app/features/profile/data/models/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/features/profile/data/models/logout_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/operation_response.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_response.dart';

part 'profile_api_client.g.dart';

@RestApi()
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio, {String baseUrl}) = _ProfileApiClient;

  @GET(ApiEndpoints.myProfile)
  Future<UserProfileResponse> getMyProfile();

  @MultiPart()
  @PUT(ApiEndpoints.updateProfile)
  Future<UserProfileResponse> updateMyProfile(
    @Part(name: ApiRequestParams.firstName) String firstName,
    @Part(name: ApiRequestParams.lastName) String lastName,
    @Part(name: ApiRequestParams.phoneNumber) String phoneNumber,
    @Part(name: ApiRequestParams.gender) String gender,
    @Part(name: ApiRequestParams.profilePicture) MultipartFile? profilePicture,
  );

  @GET(ApiEndpoints.vehicleInfo)
  Future<DriverProfileResponse> getDriverProfile();

  @MultiPart()
  @PUT(ApiEndpoints.vehicleInfo)
  Future<DriverProfileResponse> updateDriverProfile(
    @Part(name: ApiRequestParams.vehicleTypeId) String vehicleTypeId,
    @Part(name: ApiRequestParams.plateNumber) String plateNumber,
    @Part(name: ApiRequestParams.licenseDocument)
    MultipartFile? licenseDocument,
  );

  @POST(ApiEndpoints.changePassword)
  Future<OperationResponse> changePassword(
    @Body() ChangePasswordRequestDto body,
  );

  @POST(ApiEndpoints.logout)
  Future<OperationResponse> logout(@Body() LogoutRequestDto body);
}
