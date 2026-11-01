import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/constant/widget_keys.dart';

import '../../../../../../core/localization/local_key.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../data/api/order_status_api_values.dart';
import '../../view_model/order_history_state.dart';

class OrdersHistoryCount extends StatelessWidget {
  const OrdersHistoryCount({
    super.key,
    required this.completed,
    required this.cancelled,
    this.onRetry,
  });

  final OrderCountState completed;
  final OrderCountState cancelled;
  final ValueChanged<String>? onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HistoryCountCard(
            key: WidgetKeys.cancelledCountCard,
            icon: Icon(
              Icons.cancel_outlined,
              color: context.colors.error,
              size: 24.r,
            ),
            text: LocaleKeys.statusCancelled.tr(),
            count: cancelled,
            onRetry:
            onRetry == null || !cancelled.failed
                ? null
                : () => onRetry!(OrderStatusApiValues.cancelled),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: HistoryCountCard(
            key: WidgetKeys.completedCountCard,
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: context.colors.green,
              size: 24.r,
            ),
            text: LocaleKeys.statusDelivered.tr(),
            count: completed,
            onRetry:
            onRetry == null || !completed.failed
                ? null
                : () => onRetry!(OrderStatusApiValues.delivered),
          ),
        ),
      ],
    );
  }
}

class HistoryCountCard extends StatelessWidget {
  const HistoryCountCard({
    super.key,
    required this.icon,
    required this.text,
    required this.count,
    this.onRetry,
  });

  final Icon icon;
  final String text;
  final OrderCountState count;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.colors.pink.shade50.withAlpha(80),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 24.h,
              child: Center(
                child: _buildValue(context),
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

  Widget _buildValue(BuildContext context) {
    if (count.loading) {
      return SizedBox(
        width: 18.r,
        height: 18.r,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (count.failed) {
      return Icon(
        Icons.refresh_rounded,
        size: 20.r,
        color: context.colors.black,
      );
    }
    return Text(
      '${count.value ?? 0}',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
        color: context.colors.black,
      ),
    );
  }
}
