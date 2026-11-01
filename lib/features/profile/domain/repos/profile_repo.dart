import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';

abstract interface class ProfileRepo {
  Future<BaseResponse<UserProfileEntity>> getProfile();

  Future<BaseResponse<UserProfileEntity>> updateProfile(
    UpdateProfileParams params,
  );

  Future<BaseResponse<VehicleInfoEntity>> getVehicleInfo();

  Future<BaseResponse<VehicleInfoEntity>> updateVehicle(
    UpdateVehicleParams params,
  );

  Future<BaseResponse<void>> changePassword(ChangePasswordParams params);

  Future<BaseResponse<void>> logout();
}
