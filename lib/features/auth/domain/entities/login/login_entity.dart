import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String role;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, role];
}