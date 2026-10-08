import 'package:dio/dio.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';

class ApplyRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String nid;
  final String nidImagePath;
  final String vehicleTypeId;
  final String vehiclePlateNumber;
  final int vehicleCapacity;
  final String licenceImagePath;
  final int gender; // apiValue: male = 0, female = 1
  final String password;
  final String confirmPassword;
  final String fcmToken;

  const ApplyRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.nid,
    required this.nidImagePath,
    required this.vehicleTypeId,
    required this.vehiclePlateNumber,
    required this.vehicleCapacity,
    required this.licenceImagePath,
    required this.gender,
    required this.password,
    required this.confirmPassword,
    required this.fcmToken,
  });

  factory ApplyRequestModel.fromEntity(ApplyEntity entity) {
    return ApplyRequestModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      nid: entity.nid,
      nidImagePath: entity.nidImage.path,
      vehicleTypeId: entity.vehicleTypeId,
      vehiclePlateNumber: entity.vehiclePlateNumber,
      vehicleCapacity: entity.vehicleCapacity,
      licenceImagePath: entity.licenceImage.path,
      gender: entity.gender.apiValue,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      fcmToken: entity.fcmToken,
    );
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'vehicleTypeId': vehicleTypeId,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'vehicleCapacity': vehicleCapacity,
      'fcmToken': fcmToken,
      'nid': nid,
      'phone': phone,
      'vehiclePlateNumber': vehiclePlateNumber,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'licenceImage': await MultipartFile.fromFile(licenceImagePath),
      'nidImage': await MultipartFile.fromFile(nidImagePath),
    });
  }
}
