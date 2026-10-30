import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/profile_vehicle_type.dart';
import 'package:tracking_app/features/profile/presentation/profile/view/widgets/profile_card.dart';
import 'package:tracking_app/features/profile/presentation/profile/view/widgets/profile_menu.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_avatar.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      children: const [
        ProfileUserCard(),
        ProfileVehicleCard(),
        ProfileLanguageTile(),
        ProfileLogoutTile(),
        ProfileVersionLabel(),
      ],
    );
  }
}

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.select(_profile);
    if (profile == null) return const SizedBox.shrink();
    return ProfileInfoCard(
      onTap: () => openEditProfile(context),
      child: ProfileUserRow(profile: profile),
    );
  }
}

class ProfileUserRow extends StatelessWidget {
  const ProfileUserRow({required this.profile, super.key});

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileCircleAvatar(url: profile.photoUrl),
        SizedBox(width: 12.w),
        Expanded(child: ProfileUserTexts(profile: profile)),
        Icon(Icons.chevron_right, color: context.colors.grey.shade800),
      ],
    );
  }
}

class ProfileUserTexts extends StatelessWidget {
  const ProfileUserTexts({required this.profile, super.key});

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileStrongText(profile.fullName),
        ProfileMutedText(profile.email),
        ProfileMutedText(profile.phoneNumber),
      ],
    );
  }
}

class ProfileVehicleCard extends StatelessWidget {
  const ProfileVehicleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = context.select(_vehicle);
    if (vehicle == null) return const SizedBox.shrink();
    return ProfileInfoCard(
      onTap: () => openEditVehicle(context),
      child: ProfileVehicleRow(vehicle: vehicle),
    );
  }
}

class ProfileVehicleRow extends StatelessWidget {
  const ProfileVehicleRow({required this.vehicle, super.key});

  final VehicleInfoEntity vehicle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ProfileVehicleTexts(vehicle: vehicle)),
        Icon(Icons.chevron_right, color: context.colors.grey.shade800),
      ],
    );
  }
}

class ProfileVehicleTexts extends StatelessWidget {
  const ProfileVehicleTexts({required this.vehicle, super.key});

  final VehicleInfoEntity vehicle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileStrongText(LocaleKeys.profileVehicleInfo.tr()),
        ProfilePlainText(vehicleTypeLabel(vehicle.vehicleType)),
        ProfileMutedText(vehicle.vehicleNumber),
      ],
    );
  }
}

UserProfileEntity? _profile(ProfileViewModel viewModel) {
  return viewModel.state.profile.data;
}

VehicleInfoEntity? _vehicle(ProfileViewModel viewModel) {
  return viewModel.state.vehicle.data;
}

String vehicleTypeLabel(String name) {
  if (toProfileVehicleType(name) == profileMotorcycle) {
    return LocaleKeys.profileBike.tr();
  }
  return name;
}
