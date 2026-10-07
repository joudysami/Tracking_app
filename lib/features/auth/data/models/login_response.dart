import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';

class LoginResponse {
  const LoginResponse({this.status, this.message, this.data});

  final bool? status;
  final String? message;
  final LoginData? data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] == true,
      message: json['message'] as String?,
      data: _loginData(json['data']),
    );
  }
}

class LoginData {
  const LoginData({
    required this.token,
    required this.refreshToken,
    required this.user,
    this.canAccessDriverHome,
  });

  final String token;
  final String refreshToken;
  final LoginUser user;
  final bool? canAccessDriverHome;

  AuthSession toSession() {
    return AuthSession(
      role: user.role,
      driverApplicationStatus: user.driverApplicationStatus,
      canAccessDriverHome: canAccessDriverHome ?? user.canAccessDriverHome,
    );
  }

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: _requiredText(json['token'], 'token'),
      refreshToken: _requiredText(json['refreshToken'], 'refresh token'),
      user: LoginUser.fromJson(_map(json['user'])),
      canAccessDriverHome: _asBool(json['canAccessDriverHome']),
    );
  }
}

class LoginUser {
  const LoginUser({
    required this.role,
    this.driverApplicationStatus,
    this.canAccessDriverHome,
  });

  final String role;
  final String? driverApplicationStatus;
  final bool? canAccessDriverHome;

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      role: _firstRole(json['roles']),
      driverApplicationStatus: _optionalText(json['driverApplicationStatus']),
      canAccessDriverHome: _asBool(json['canAccessDriverHome']),
    );
  }
}

LoginData? _loginData(dynamic raw) {
  if (raw == null) return null;
  return LoginData.fromJson(_map(raw));
}

Map<String, dynamic> _map(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  throw const FormatException('Login response is missing data');
}

String _requiredText(dynamic value, String label) {
  if (value is String && value.isNotEmpty) return value;
  throw FormatException('Login response is missing a $label');
}

String _firstRole(dynamic roles) {
  if (roles is! List || roles.isEmpty || roles.first is! String) return '';
  return roles.first as String;
}

String? _optionalText(dynamic value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value;
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  return null;
}
