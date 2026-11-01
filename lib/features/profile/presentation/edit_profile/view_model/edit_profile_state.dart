import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';

class EditProfileState extends Equatable {
  final BaseState<UserProfileEntity> profile;
  final BaseState<UserProfileEntity> submit;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final Gender? gender;
  final String? photoPath;

  const EditProfileState({
    this.profile = const BaseState(),
    this.submit = const BaseState(),
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.gender,
    this.photoPath,
  });

  EditProfileState copyWith({
    BaseState<UserProfileEntity>? profile,
    BaseState<UserProfileEntity>? submit,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    Gender? gender,
    String? photoPath,
  }) {
    return _copied(
      this,
      profile,
      submit,
      firstName,
      lastName,
      email,
      phone,
      gender,
      photoPath,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    submit,
    firstName,
    lastName,
    email,
    phone,
    gender,
    photoPath,
  ];
}

EditProfileState _copied(
  EditProfileState state,
  BaseState<UserProfileEntity>? profile,
  BaseState<UserProfileEntity>? submit,
  String? firstName,
  String? lastName,
  String? email,
  String? phone,
  Gender? gender,
  String? photoPath,
) {
  return EditProfileState(
    profile: profile ?? state.profile,
    submit: submit ?? state.submit,
    firstName: firstName ?? state.firstName,
    lastName: lastName ?? state.lastName,
    email: email ?? state.email,
    phone: phone ?? state.phone,
    gender: gender ?? state.gender,
    photoPath: photoPath ?? state.photoPath,
  );
}
