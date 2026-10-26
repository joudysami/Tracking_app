import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({required this.title, this.showBell = false, super.key});

  final String title;
  final bool showBell;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: showBell ? const [NotificationBell()] : const <Widget>[],
    );
  }
}

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.notifications_outlined, color: context.colors.black),
    );
  }
}

class ProfileBottomNav extends StatelessWidget {
  const ProfileBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.white,
        border: Border(top: BorderSide(color: context.colors.grey.shade600)),
      ),
      child: const SafeArea(child: ProfileNavRow()),
    );
  }
}

class ProfileNavRow extends StatelessWidget {
  const ProfileNavRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ProfileNavItem(icon: Icons.home_outlined, labelKey: LocaleKeys.navHome),
        ProfileNavItem(
          icon: Icons.assignment_outlined,
          labelKey: LocaleKeys.navOrders,
        ),
        ProfileNavItem(
          icon: Icons.person,
          labelKey: LocaleKeys.navProfile,
          selected: true,
        ),
      ],
    );
  }
}

class ProfileNavItem extends StatelessWidget {
  const ProfileNavItem({
    required this.icon,
    required this.labelKey,
    this.selected = false,
    super.key,
  });

  final IconData icon;
  final String labelKey;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? context.colors.pink : context.colors.grey.shade800;
    return Expanded(
      child: ProfileNavLabel(icon: icon, label: labelKey.tr(), color: color),
    );
  }
}

class ProfileNavLabel extends StatelessWidget {
  const ProfileNavLabel({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
