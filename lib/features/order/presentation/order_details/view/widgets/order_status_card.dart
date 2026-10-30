import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/order/core/order_status_progress.dart';

class OrderStatusCard extends StatelessWidget {
  final AvailableOrderEntity order;

  const OrderStatusCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF6D5E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (order.status.trim().isNotEmpty) _statusLine(),
          const SizedBox(height: 6),
          Text(
            '${LocaleKeys.orderDetailsOrderId.tr()} : ${order.orderId}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            formatOrderCreatedAt(
              order.createdAt,
              labels: currentOrderDateLabels(),
            ),
            style: const TextStyle(fontSize: 13, color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }

  Widget _statusLine() {
    return Text(
      '${LocaleKeys.orderDetailsStatus.tr()} : ${_statusLabel(order.status)}',
      style: const TextStyle(
        color: Color(0xFF1FA84A),
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  String _statusLabel(String status) {
    final key = orderStatusLocalizationKey(status);
    if (key == null) return status.trim();
    return key.tr();
  }
}
