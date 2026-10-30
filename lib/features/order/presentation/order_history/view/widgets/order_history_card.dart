import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/order/data/mappers/order_history_status_mapper.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/complete_or_cancelled_text.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/order_address_card.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.order, this.onTap});

  final OrderHistoryEntity order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10.r,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.homeFlowerOrder.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: context.colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CompleteOrCancelledText(status: order.status.toCardStatus()),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    order.orderNumber ?? '_',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: context.colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            OrderAddressCard(isStore: true),
            SizedBox(height: 16.h),
            OrderAddressCard(
              addressLine: order.destination?.addressLine ?? '_',
              userName: order.destination?.recipientName ?? '_',
            ),
          ],
        ),
      ),
    );
  }
}
