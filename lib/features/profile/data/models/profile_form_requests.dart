import 'package:dio/dio.dart';
import 'package:tracking_app/features/profile/data/mapper/profile_gender_mapper.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';

class UpdateProfileRequest {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String gender;
  final MultipartFile? photo;

  const UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.photo,
  });

  static Future<UpdateProfileRequest> fromParams(
    UpdateProfileParams params,
  ) async {
    return UpdateProfileRequest(
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
      gender: genderToApi(params.gender),
      photo: await optionalFile(params.photoPath),
    );
  }
}

class UpdateVehicleRequest {
  final String vehicleTypeId;
  final String plateNumber;
  final MultipartFile? license;

  const UpdateVehicleRequest({
    required this.vehicleTypeId,
    required this.plateNumber,
    required this.license,
  });

  static Future<UpdateVehicleRequest> fromParams(
    UpdateVehicleParams params,
  ) async {
    return UpdateVehicleRequest(
      vehicleTypeId: params.vehicleTypeId,
      plateNumber: params.vehicleNumber,
      license: await optionalFile(params.licensePath),
    );
  }
}

Future<MultipartFile?> optionalFile(String? path) async {
  if (path == null || path.isEmpty) return null;
  return MultipartFile.fromFile(path);
}
