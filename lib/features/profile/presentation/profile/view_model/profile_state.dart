import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';

class ProfileState extends Equatable {
  final BaseState<UserProfileEntity> profile;
  final BaseState<VehicleInfoEntity> vehicle;
  final bool isLoggingOut;

  const ProfileState({
    this.profile = const BaseState(),
    this.vehicle = const BaseState(),
    this.isLoggingOut = false,
  });

  ProfileState copyWith({
    BaseState<UserProfileEntity>? profile,
    BaseState<VehicleInfoEntity>? vehicle,
    bool? isLoggingOut,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      vehicle: vehicle ?? this.vehicle,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => [profile, vehicle, isLoggingOut];
}
