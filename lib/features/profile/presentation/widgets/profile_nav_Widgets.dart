import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
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
  const ProfileBottomNav({this.currentIndex = 2, this.onTap, super.key});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.white,
        border: Border(top: BorderSide(color: context.colors.grey.shade600)),
      ),
      child: SafeArea(child: ProfileNavRow(currentIndex: currentIndex, onTap: onTap)),
    );
  }
}

class ProfileNavRow extends StatelessWidget {
  const ProfileNavRow({this.currentIndex = 2, this.onTap, super.key});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.orderMap);
      case 2:
        context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileNavItem(
          icon: Icons.home_outlined,
          labelKey: LocaleKeys.navHome,
          selected: currentIndex == 0,
          onTap: () => _handleTap(context, 0),
        ),
        ProfileNavItem(
          icon: Icons.assignment_outlined,
          labelKey: LocaleKeys.navOrders,
          selected: currentIndex == 1,
          onTap: () => _handleTap(context, 1),
        ),
        ProfileNavItem(
          icon: Icons.person,
          labelKey: LocaleKeys.navProfile,
          selected: currentIndex == 2,
          onTap: () => _handleTap(context, 2),
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
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String labelKey;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? context.colors.pink : context.colors.grey.shade800;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: ProfileNavLabel(icon: icon, label: labelKey.tr(), color: color),
      ),
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
