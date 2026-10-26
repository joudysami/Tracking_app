import 'package:tracking_app/features/profile/data/models/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/features/profile/data/models/operation_response.dart';
import 'package:tracking_app/features/profile/data/models/profile_form_requests.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_response.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfileResponse> getProfile();

  Future<UserProfileResponse> updateProfile(UpdateProfileRequest request);

  Future<DriverProfileResponse> getVehicle();

  Future<DriverProfileResponse> updateVehicle(UpdateVehicleRequest request);

  Future<OperationResponse> changePassword(ChangePasswordRequestDto request);

  Future<OperationResponse> logout(String refreshToken);
}
