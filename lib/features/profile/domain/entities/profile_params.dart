import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Gender gender;
  final String? photoPath;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.photoPath,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phoneNumber,
    gender,
    photoPath,
  ];
}

class UpdateVehicleParams extends Equatable {
  final String vehicleTypeId;
  final String vehicleNumber;
  final String? licensePath;

  const UpdateVehicleParams({
    required this.vehicleTypeId,
    required this.vehicleNumber,
    required this.licensePath,
  });

  @override
  List<Object?> get props => [vehicleTypeId, vehicleNumber, licensePath];
}

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}
