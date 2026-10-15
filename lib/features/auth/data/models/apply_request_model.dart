import 'package:dio/dio.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';

class ApplyRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String nid;
  final MultipartFile nidImage;
  final String vehicleTypeId;
  final String vehiclePlateNumber;
  final int vehicleCapacity;
  final MultipartFile licenceImage;
  final int gender;
  final String password;
  final String confirmPassword;
  final String fcmToken;

  const ApplyRequestModel({
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

  static Future<ApplyRequestModel> fromEntity(
    ApplyParams entity,
  ) async {
    final licenceImage = await MultipartFile.fromFile(
      entity.licenceImage,
    );

    final nidImage = await MultipartFile.fromFile(
      entity.nidImage,
    );

    return ApplyRequestModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      nid: entity.nid,
      nidImage: nidImage,
      vehicleTypeId: entity.vehicleTypeId,
      vehiclePlateNumber: entity.vehiclePlateNumber,
      vehicleCapacity: entity.vehicleCapacity,
      licenceImage: licenceImage,
      gender: entity.gender.apiValue,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      fcmToken: entity.fcmToken,
    );
  }

  FormData toFormData() {
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
      'licenceImage': licenceImage,
      'nidImage': nidImage,
    });
  }
}
