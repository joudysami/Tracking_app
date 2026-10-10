import 'package:equatable/equatable.dart';

class ApplyResultEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? role;
  final String gender;
  final String notificationStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ApplyResultEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role,
    required this.gender,
    required this.notificationStatus,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        role,
        gender,
        notificationStatus,
        createdAt,
        updatedAt,
      ];
}
