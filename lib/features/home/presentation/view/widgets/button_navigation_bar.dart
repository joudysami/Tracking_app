import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/home/presentation/view/screen/home_screen.dart';
import 'package:tracking_app/features/order/order_screen.dart';
import 'package:tracking_app/features/profile/profile.dart';

class ButtonNavigationBar extends StatefulWidget {
  const ButtonNavigationBar({super.key});

  @override
  State<ButtonNavigationBar> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<ButtonNavigationBar> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: LocaleKeys.navHome.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: LocaleKeys.navOrders.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: LocaleKeys.navProfile.tr(),
          ),
        ],
      ),
    );
  }
}
