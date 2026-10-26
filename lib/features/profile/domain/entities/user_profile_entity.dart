import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';

class UserProfileEntity extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final Gender? gender;
  final String? photoUrl;

  const UserProfileEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    fullName,
    email,
    phoneNumber,
    gender,
    photoUrl,
  ];
}
