import 'package:flutter/material.dart';
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
