import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/flowery_store_logo.dart';
import 'package:tracking_app/core/widgets/order_address_tile.dart';

class FlowerOrderModel {
  const FlowerOrderModel({
    required this.id,
    this.title,
    this.storeName,
    required this.pickupAddress,
    required this.userName,
    required this.userAddress,
    this.userAvatarUrl,
    required this.price,
    this.currency,
  });

  final String id;
  final String? title;
  final String? storeName;
  final String pickupAddress;
  final String userName;
  final String userAddress;
  final String? userAvatarUrl;
  final String price;
  final String? currency;
}

class FlowerOrderCard extends StatelessWidget {
  const FlowerOrderCard({
    super.key,
    this.orderTitle,
    this.pickupLabel,
    this.pickupStoreName,
    required this.pickupAddress,
    this.pickupLeading,
    this.userLabel,
    required this.userName,
    required this.userAddress,
    this.userAvatar,
    this.userAvatarUrl,
    required this.price,
    this.currency,
    this.acceptText,
    this.onAccept,
    this.onPickupTap,
    this.onUserTap,
    this.onCardTap,
  });

  factory FlowerOrderCard.fromModel({
    Key? key,
    required FlowerOrderModel order,
    VoidCallback? onAccept,
    VoidCallback? onPickupTap,
    VoidCallback? onUserTap,
    VoidCallback? onCardTap,
  }) {
    return FlowerOrderCard(
      key: key,
      orderTitle: order.title,
      pickupStoreName: order.storeName,
      pickupAddress: order.pickupAddress,
      userName: order.userName,
      userAddress: order.userAddress,
      userAvatarUrl: order.userAvatarUrl,
      price: order.price,
      currency: order.currency,
      onAccept: onAccept,
      onPickupTap: onPickupTap,
      onUserTap: onUserTap,
      onCardTap: onCardTap,
    );
  }

  final String? orderTitle;
  final String? pickupLabel;
  final String? pickupStoreName;
  final String pickupAddress;
  final Widget? pickupLeading;

  final String? userLabel;
  final String userName;
  final String userAddress;
  final Widget? userAvatar;
  final String? userAvatarUrl;

  final String price;
  final String? currency;
  final String? acceptText;
  final VoidCallback? onAccept;
  final VoidCallback? onPickupTap;
  final VoidCallback? onUserTap;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final resolvedTitle = orderTitle ?? LocaleKeys.homeFlowerOrder.tr();
    final resolvedPickupLabel =
        pickupLabel ?? LocaleKeys.homePickupAddress.tr();
    final resolvedStoreName =
        pickupStoreName ?? LocaleKeys.homeFloweryStore.tr();
    final resolvedUserLabel = userLabel ?? LocaleKeys.homeUserAddress.tr();
    final resolvedCurrency = currency ?? LocaleKeys.homeEgp.tr();
    final resolvedAcceptText = acceptText ?? LocaleKeys.homeAccept.tr();

    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: colors.grey.shade600.withValues(alpha: 0.25),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order title
            Text(
              resolvedTitle,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: colors.black[90] ?? colors.black,
              ),
            ),
            SizedBox(height: 12.h),

            // Pickup section
            Text(
              resolvedPickupLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: colors.grey.shade700,
              ),
            ),
            SizedBox(height: 6.h),
            OrderAddressTile(
              leading: pickupLeading ?? const FloweryStoreLogo(),
              title: resolvedStoreName,
              address: pickupAddress,
              onTap: onPickupTap,
            ),
            SizedBox(height: 12.h),

            // User section
            Text(
              resolvedUserLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: colors.grey.shade700,
              ),
            ),
            SizedBox(height: 6.h),
            OrderAddressTile(
              leading: userAvatar ?? _buildUserAvatar(colors),
              title: userName,
              address: userAddress,
              onTap: onUserTap,
            ),
            SizedBox(height: 16.h),

            // Bottom action row: Price & Accept button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$resolvedCurrency $price',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.black[90] ?? colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.pink,
                    foregroundColor: colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 26.w,
                      vertical: 9.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                  child: Text(
                    resolvedAcceptText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(AppColors colors) {
    final avatarSize = 42.w;

    if (userAvatarUrl != null && userAvatarUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: Image.network(
          userAvatarUrl!,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildFallbackAvatar(colors, avatarSize),
        ),
      );
    }

    return _buildFallbackAvatar(colors, avatarSize);
  }

  Widget _buildFallbackAvatar(AppColors colors, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.pink.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: colors.pink.shade700,
          size: size * 0.6,
        ),
      ),
    );
  }
}
