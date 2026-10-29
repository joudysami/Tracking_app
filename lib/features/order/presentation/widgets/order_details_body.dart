import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';
import 'package:tracking_app/features/order/domain/order_status_progress.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_item_card.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_party_card.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_payment_method_card.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_progress_bar.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_section_tile.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_status_card.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_total_card.dart';

class OrderDetailsBody extends StatelessWidget {
  final OrderDetailsEntity order;
  final ScrollController scrollController;

  const OrderDetailsBody({
    super.key,
    required this.order,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(order.createdAt) ?? DateTime.now();

    final storeName = order.storeName.trim().isEmpty
        ? LocaleKeys.orderDetailsUnknownStore.tr()
        : order.storeName.trim();

    final storeAddress = order.storeAddress.trim().isEmpty
        ? LocaleKeys.orderDetailsNoAddress.tr()
        : order.storeAddress.trim();

    final customerAddress = order.customerAddress.trim().isEmpty
        ? LocaleKeys.orderDetailsNoAddress.tr()
        : order.customerAddress.trim();

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        OrderProgressBar(
          completed: completedOrderProgressSegments(order.status),
        ),
        const SizedBox(height: 16),

        OrderStatusCard(
          status: order.status,
          orderId: order.orderId,
          createdAt: createdAt,
        ),
        const SizedBox(height: 20),

        OrderSectionTitle(title: LocaleKeys.orderDetailsPickupAddress.tr()),
        OrderPartyCard(title: storeName, address: storeAddress, isStore: true),
        const SizedBox(height: 20),

        OrderSectionTitle(title: LocaleKeys.orderDetailsUserAddress.tr()),
        OrderPartyCard(
          title: order.customerName.trim(),
          address: customerAddress,
        ),
        const SizedBox(height: 20),

        OrderSectionTitle(title: LocaleKeys.orderDetailsTitle.tr()),
        for (final item in order.items) ...[
          OrderItemCard(item: item),
          const SizedBox(height: 12),
        ],

        const SizedBox(height: 8),
        OrderTotalCard(amount: order.totalAmount),
        const SizedBox(height: 12),

        OrderPaymentMethodCard(paymentMethod: order.paymentMethod),
      ],
    );
  }
}
