import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool status;
  final int code;
  final String message;

  /// Null when login failed or the token payload is missing or malformed.
  @JsonKey(fromJson: LoginData.fromNullableJson)
  final LoginData? data;

  LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginData {
  @JsonKey(name: 'token')
  final String accessToken;
  final String refreshToken;
  final LoginUser? user;

  LoginData({required this.accessToken, required this.refreshToken, this.user});

  /// Reads a success payload. Returns null for `data: null`, a non-object,
  /// or a payload whose token fields are missing or not non-empty strings.
  static LoginData? fromNullableJson(Object? json) {
    if (json is! Map) return null;
    final token = json['token'];
    final refreshToken = json['refreshToken'];
    if (token is! String || token.isEmpty) return null;
    if (refreshToken is! String || refreshToken.isEmpty) return null;
    return LoginData(
      accessToken: token,
      refreshToken: refreshToken,
      user: _userFromJson(json['user']),
    );
  }

  static LoginUser? _userFromJson(Object? json) {
    if (json is! Map) return null;
    final roles = json['roles'];
    if (roles is! List) return const LoginUser();
    final values = <String>[];
    for (final role in roles) {
      if (role is! String) return const LoginUser();
      values.add(role);
    }
    return LoginUser(roles: values);
  }

  LoginEntity toDomain() {
    return LoginEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: user?.role ?? '',
    );
  }

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginUser {
  final List<String>? roles;

  const LoginUser({this.roles});

  String get role {
    final values = roles;
    if (values == null || values.isEmpty) return '';
    return values.first;
  }

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}
