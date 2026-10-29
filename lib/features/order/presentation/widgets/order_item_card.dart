import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_item_entity.dart';
import 'package:tracking_app/features/order/domain/order_status_progress.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemCard({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.w),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.local_florist,
                        color: context.colors.pink,
                        size: 26.sp,
                      ),
                    ),
                  )
                : _placeholderIcon(),
          ),
         SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.colors.black.shade50,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'EGP ${formatOrderAmount(item.price)}',
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.black.shade100
                  ),
                ),
              ],
            ),
          ),
          Text(
            'X${item.quantity}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.colors.pink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderIcon() {
    return const Center(
      child: Icon(Icons.local_florist, color: Color(0xFFE91E63), size: 26),
    );
  }
}
