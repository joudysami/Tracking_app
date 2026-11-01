import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_event.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/logout_dialog.dart';

Future<void> openEditProfile(BuildContext context) {
  return _openEditor(context, AppRoutes.editProfile);
}

Future<void> openEditVehicle(BuildContext context) {
  return _openEditor(context, AppRoutes.editVehicle);
}

Future<void> _openEditor(BuildContext context, String route) async {
  final updated = await context.push<bool>(route);
  if (updated != true || !context.mounted) return;
  context.read<ProfileViewModel>().doEvent(const ProfileRequested());
}

Future<void> confirmLogout(BuildContext context) async {
  final approved = await showLogoutDialog(context);
  if (!approved || !context.mounted) return;
  context.read<ProfileViewModel>().doEvent(const LogoutConfirmed());
}

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({required this.onTap, required this.child, super.key});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: ProfileCardSurface(onTap: onTap, child: child),
    );
  }
}

class ProfileCardSurface extends StatelessWidget {
  const ProfileCardSurface({
    required this.onTap,
    required this.child,
    super.key,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.white,
      shape: _cardShape(context),
      child: ProfileCardTap(onTap: onTap, child: child),
    );
  }
}

class ProfileCardTap extends StatelessWidget {
  const ProfileCardTap({required this.onTap, required this.child, super.key});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(padding: EdgeInsets.all(16.w), child: child),
    );
  }
}

ShapeBorder _cardShape(BuildContext context) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.r),
    side: BorderSide(color: context.colors.grey.shade600),
  );
}
