import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';

class OrderPaymentMethodCard extends StatelessWidget {
  final String paymentMethod;

  const OrderPaymentMethodCard({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    final displayMethod = paymentMethod.trim().isEmpty
        ? LocaleKeys.orderDetailsCash.tr()
        : paymentMethod;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 16.w),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Text(
            LocaleKeys.orderDetailsPaymentMethod.tr(),
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            displayMethod,
            style: TextStyle(fontSize: 14.sp, color: context.colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
