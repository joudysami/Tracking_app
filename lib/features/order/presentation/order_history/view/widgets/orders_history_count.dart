import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/local_key.dart';
import '../../../../../../core/theme/app_color.dart';

class OrdersHistoryCount extends StatelessWidget {
  const OrdersHistoryCount({
    super.key,
    required this.completedCount,
    required this.cancelledCount,
  });

  final int? completedCount;
  final int? cancelledCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCard(
          context,
          icon: Icon(
            Icons.cancel_outlined,
            color: context.colors.error,
            size: 24.r,
          ),
          text: LocaleKeys.statusCancelled.tr(),
          count: cancelledCount ?? 0,
        ),
        SizedBox(width: 16.w),
        _buildCard(
          context,
          icon: Icon(
            Icons.check_circle_outline_rounded,
            color: context.colors.green,
            size: 24.r,
          ),
          text: LocaleKeys.statusDelivered.tr(),
          count: completedCount ?? 0,
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required Icon icon,
    required String text,
    required int count,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.colors.pink.shade50.withAlpha(80),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: context.colors.black,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 4.w),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: context.colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
