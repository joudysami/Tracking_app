import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson({
        ...json,
        'isSuccess': json['isSuccess'] ?? json['success'] ?? false,
      });

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String role;
  final String? driverApplicationStatus;
  final bool canAccessDriverHome;
  final String? driverApplicationRejectionReason;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.role,
    this.driverApplicationStatus,
    required this.canAccessDriverHome,
    this.driverApplicationRejectionReason,
  });

  LoginEntity toDomain() {
    return LoginEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
      
    );
  }

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}