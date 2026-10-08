import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart'; // ← الناقص

part 'apply_response.g.dart';

@JsonSerializable()
class ApplyResponse {
  final bool? status;
  final int? code;
  final String? message;
  final ApplyData? data;
  final dynamic pagination;
  final dynamic errors;

  ApplyResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory ApplyResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApplyResponseToJson(this);
}

@JsonSerializable()
class ApplyData {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? gender;

  @JsonKey(
    name: 'notifcationStatus',
  ) 
  final String? notificationStatus;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  ApplyData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.gender,
    this.notificationStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory ApplyData.fromJson(Map<String, dynamic> json) =>
      _$ApplyDataFromJson(json);
  Map<String, dynamic> toJson() => _$ApplyDataToJson(this);

  ApplyResultEntity toDomain() => ApplyResultEntity(
    id: id ?? '',
    name: name ?? '',
    email: email ?? '',
    phone: phone ?? '',
    role: role,
    gender: gender ?? '',
    notificationStatus: notificationStatus ?? '',
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
