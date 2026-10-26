import 'package:tracking_app/features/profile/data/mapper/profile_gender_mapper.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileDto {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? profilePictureUrl;

  const UserProfileDto({
    this.userId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      userId: (json['id'] ?? json['userId'])?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      gender: json['gender']?.toString(),
      profilePictureUrl: json['profilePictureUrl']?.toString(),
    );
  }

  UserProfileEntity toEntity() => _entity(this);
}

UserProfileEntity _entity(UserProfileDto dto) {
  final first = dto.firstName ?? '';
  final last = dto.lastName ?? '';
  final joined = '$first $last'.trim();
  final name = dto.fullName;
  return UserProfileEntity(
    userId: dto.userId ?? '',
    firstName: first,
    lastName: last,
    fullName: name == null || name.isEmpty ? joined : name,
    email: dto.email ?? '',
    phoneNumber: dto.phoneNumber ?? '',
    gender: genderFromApi(dto.gender),
    photoUrl: dto.profilePictureUrl,
  );
}
