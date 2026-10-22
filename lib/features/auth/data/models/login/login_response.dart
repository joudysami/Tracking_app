import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'status')
  final bool isSuccess;

  @JsonKey(name: 'code')
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
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginData {
  final LoginUser? user;

  @JsonKey(name: 'token')
  final String accessToken;

  final String refreshToken;
  @JsonKey(defaultValue: '')
  final String accessTokenExpiresAt;

  LoginData({
    this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
  });

  LoginEntity toDomain() {
    return LoginEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: user?.roles.isNotEmpty == true ? user!.roles.first : '',
    );
  }

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginUser {
  final String id;
  final String email;
  final List<String> roles;

  // The Driver login response returns name instead of firstName/lastName.
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  LoginUser({
    required this.id,
    required this.email,
    required this.roles,
    this.name = '',
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}

LoginData loginDataFromJson(dynamic raw) {
  if (raw is Map<String, dynamic>) {
    return LoginData.fromJson(raw);
  }

  if (raw is List &&
      raw.isNotEmpty &&
      raw.first is Map<String, dynamic>) {
    return LoginData.fromJson(raw.first as Map<String, dynamic>);
  }

  throw const FormatException('Login response data is not valid.');
}

LoginUser? loginUserFromJson(dynamic raw) {
  if (raw is Map<String, dynamic>) {
    return LoginUser.fromJson(raw);
  }

  if (raw is List && raw.isNotEmpty && raw.first is Map<String, dynamic>) {
    return LoginUser.fromJson(raw.first as Map<String, dynamic>);
  }

  return null;
}
