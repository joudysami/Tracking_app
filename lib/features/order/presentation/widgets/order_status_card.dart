import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/order/domain/order_status_progress.dart';

class OrderStatusCard extends StatelessWidget {
  final String status;
  final String orderId;
  final DateTime? createdAt;
  final AvailableOrderEntity? order;

  const OrderStatusCard({
    super.key,
    this.order,
    this.status = '',
    this.orderId = '',
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStatus =
        status.isNotEmpty ? status : (order?.status ?? '');
    final effectiveOrderId =
        orderId.isNotEmpty ? orderId : (order?.orderId ?? '');
    final effectiveDate = createdAt ?? order?.createdAt ?? DateTime.now();

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
          if (effectiveStatus.trim().isNotEmpty)
            _statusLine(effectiveStatus),
          const SizedBox(height: 6),
          _orderIdLine(effectiveOrderId),
          const SizedBox(height: 6),
          Text(
            formatOrderCreatedAt(
              effectiveDate,
              labels: currentOrderDateLabels(),
            ),
            style: const TextStyle(fontSize: 13, color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }

  Widget _statusLine(String displayStatus) {
    return Row(
      children: [
        Text(
          '${LocaleKeys.orderDetailsStatus.tr()} : ',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        Text(
          _statusLabel(displayStatus),
          style: const TextStyle(
            color: Color(0xFF1FA84A),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _orderIdLine(String displayId) {
    final formattedId = displayId.startsWith('#') ? displayId : '# $displayId';
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
        children: [
          TextSpan(
            text: '${LocaleKeys.orderDetailsOrderId.tr()} : ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: formattedId,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    final key = orderStatusLocalizationKey(status);
    if (key == null) return status.trim();
    return key.tr();
  }
}
