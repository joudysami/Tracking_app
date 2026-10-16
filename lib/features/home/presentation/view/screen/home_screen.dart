import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:tracking_app/core/widgets/flower_order_card.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  // Sample order items matching the UI design
  final List<FlowerOrderModel> _orders = const [
    FlowerOrderModel(
      id: '1',
      pickupAddress: '20th st, Sheikh Zayed, Giza',
      userName: 'Nour mohamed',
      userAddress: '20th st, Sheikh Zayed, Giza',
      userAvatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=256&q=80',
      price: '3000',
    ),
    FlowerOrderModel(
      id: '2',
      pickupAddress: '20th st, Sheikh Zayed, Giza',
      userName: 'Nour mohamed',
      userAddress: '20th st, Sheikh Zayed, Giza',
      userAvatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=256&q=80',
      price: '3000',
    ),
    FlowerOrderModel(
      id: '3',
      pickupAddress: '20th st, Sheikh Zayed, Giza',
      userName: 'Nour mohamed',
      userAddress: '20th st, Sheikh Zayed, Giza',
      userAvatarUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=256&q=80',
      price: '3000',
    ),
  ];

  void _onAcceptOrder(FlowerOrderModel order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted order for ${order.userName}'),
        backgroundColor: context.colors.pink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: _orders.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return FlowerOrderCard.fromModel(
                    order: order,
                    onAccept: () => _onAcceptOrder(order),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }
}
