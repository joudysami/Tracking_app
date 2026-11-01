import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/profile/api/profile_api_client.dart';
import 'package:tracking_app/features/profile/data/models/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/features/profile/data/models/logout_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/operation_response.dart';
import 'package:tracking_app/features/profile/data/models/profile_form_requests.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_response.dart';

import 'profile_remote_data_source.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._client);

  final ProfileApiClient _client;

  @override
  Future<UserProfileResponse> getProfile() => _client.getMyProfile();

  @override
  Future<UserProfileResponse> updateProfile(UpdateProfileRequest request) {
    return _client.updateMyProfile(
      request.firstName,
      request.lastName,
      request.phoneNumber,
      request.gender,
      request.photo,
    );
  }

  @override
  Future<DriverProfileResponse> getVehicle() => _client.getDriverProfile();

  @override
  Future<DriverProfileResponse> updateVehicle(UpdateVehicleRequest request) {
    return _client.updateDriverProfile(
      request.vehicleTypeId,
      request.plateNumber,
      request.license,
    );
  }

  @override
  Future<OperationResponse> changePassword(ChangePasswordRequestDto request) {
    return _client.changePassword(request);
  }

  @override
  Future<OperationResponse> logout(String refreshToken) {
    return _client.logout(LogoutRequestDto(refreshToken));
  }
}
