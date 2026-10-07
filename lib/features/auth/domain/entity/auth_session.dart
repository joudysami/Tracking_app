import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.role,
    this.driverApplicationStatus,
    this.canAccessDriverHome,
  });

  final String role;
  final String? driverApplicationStatus;
  final bool? canAccessDriverHome;

  @override
  List<Object?> get props => [
    role,
    driverApplicationStatus,
    canAccessDriverHome,
  ];
}
