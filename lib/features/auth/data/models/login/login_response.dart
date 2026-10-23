import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool status;
  final int code;
  final String message;
  final LoginData data;

  const LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginData {
  final UserModel user;
  final String token;
  final String refreshToken;

  const LoginData({
    required this.user,
    required this.token,
    required this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
  LoginEntity toDomain() {
    return LoginEntity(
      accessToken: token,
      refreshToken: refreshToken,
      role: user.roles.isNotEmpty ? user.roles.first : '',
    );
  }
}

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String phone;
  final String name;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String gender;
  final String notificationStatus;

  const UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    required this.gender,
    required this.notificationStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

