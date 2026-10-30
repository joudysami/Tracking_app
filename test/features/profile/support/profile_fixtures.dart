import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/repos/profile_repo.dart';

const sampleProfile = UserProfileEntity(
  userId: '1',
  firstName: 'John',
  lastName: 'Doe',
  fullName: 'John Doe',
  email: 'john.doe@gmail.com',
  phoneNumber: '01211345678',
  gender: Gender.male,
  photoUrl: null,
);

const sampleVehicle = VehicleInfoEntity(
  vehicleTypeId: 'type-1',
  vehicleType: 'Motorcycle',
  vehicleNumber: 'UP16DL0007',
  licenseFileName: 'Photo_12345678',
);

class ScriptedProfileRepo implements ProfileRepo {
  BaseResponse<UserProfileEntity> profile = const SuccessResponse(
    sampleProfile,
  );
  BaseResponse<UserProfileEntity> updated = const SuccessResponse(
    sampleProfile,
  );
  BaseResponse<VehicleInfoEntity> vehicle = const SuccessResponse(
    sampleVehicle,
  );
  BaseResponse<void> password = const SuccessResponse(null);
  BaseResponse<void> loggedOut = const SuccessResponse(null);
  UpdateProfileParams? lastProfile;
  UpdateVehicleParams? lastVehicle;
  ChangePasswordParams? lastPassword;
  int logoutCalls = 0;

  @override
  Future<BaseResponse<UserProfileEntity>> getProfile() async => profile;

  @override
  Future<BaseResponse<UserProfileEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    lastProfile = params;
    return updated;
  }

  @override
  Future<BaseResponse<VehicleInfoEntity>> getVehicleInfo() async => vehicle;

  @override
  Future<BaseResponse<VehicleInfoEntity>> updateVehicle(
    UpdateVehicleParams params,
  ) async {
    lastVehicle = params;
    return vehicle;
  }

  @override
  Future<BaseResponse<void>> changePassword(ChangePasswordParams params) async {
    lastPassword = params;
    return password;
  }

  @override
  Future<BaseResponse<void>> logout() async {
    logoutCalls++;
    return loggedOut;
  }
}
