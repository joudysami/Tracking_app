import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';

class ApplyParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String nid;
  final String nidImage;
  final String vehicleTypeId;
  final String vehiclePlateNumber;
  final int vehicleCapacity;
  final String licenceImage;
  final Gender gender;
  final String password;
  final String confirmPassword;
  final String fcmToken;

  const ApplyParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.nid,
    required this.nidImage,
    required this.vehicleTypeId,
    required this.vehiclePlateNumber,
    required this.vehicleCapacity,
    required this.licenceImage,
    required this.gender,
    required this.password,
    required this.confirmPassword,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        nid,
        nidImage,
        vehicleTypeId,
        vehiclePlateNumber,
        vehicleCapacity,
        licenceImage,
        gender,
        password,
        confirmPassword,
        fcmToken,
      ];
}
