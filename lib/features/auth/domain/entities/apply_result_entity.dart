class ApplyResultEntity {
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
}
