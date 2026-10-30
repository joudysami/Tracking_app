import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/core/order_status_progress.dart';

class OrderTotalCard extends StatelessWidget {
  final double amount;

  const OrderTotalCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Text(
            LocaleKeys.orderDetailsTotal.tr(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            '${LocaleKeys.orderDetailsCurrency.tr()} ${formatOrderAmount(amount)}',
            style: const TextStyle(fontSize: 14, color: Color(0xFF9A9A9A)),
          ),
        ],
      ),
    );
  }
}
