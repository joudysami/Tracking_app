import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/order/core/order_status_progress.dart';

import '../widgets/order_party_card.dart';
import '../widgets/order_progress_bar.dart';
import '../widgets/order_status_card.dart';
import '../widgets/order_total_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  final AvailableOrderEntity? order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.white,
      appBar: AppBar(title: Text(LocaleKeys.orderDetailsTitle.tr())),
      body: order == null
          ? const _MissingOrderDetails()
          : _OrderDetailsBody(order: order!),
    );
  }
}

class _MissingOrderDetails extends StatelessWidget {
  const _MissingOrderDetails();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          LocaleKeys.orderDetailsUnavailable.tr(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _OrderDetailsBody extends StatelessWidget {
  final AvailableOrderEntity order;

  const _OrderDetailsBody({required this.order});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        OrderProgressBar(
          completed: completedOrderProgressSegments(order.status),
        ),
        const SizedBox(height: 16),
        OrderStatusCard(order: order),
        const SizedBox(height: 20),
        _party(
          LocaleKeys.orderDetailsPickupAddress.tr(),
          _storeTitle(order.storeName),
          _address(order.storeAddress),
          isStore: true,
        ),
        const SizedBox(height: 20),
        _party(
          LocaleKeys.orderDetailsUserAddress.tr(),
          order.customerName.trim(),
          _address(order.customerAddress),
        ),
        const SizedBox(height: 20),
        OrderTotalCard(amount: order.totalAmount),
      ],
    );
  }

  Widget _party(
    String label,
    String title,
    String address, {
    bool isStore = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(label),
        OrderPartyCard(title: title, address: address, isStore: isStore),
      ],
    );
  }

  String _storeTitle(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return LocaleKeys.orderDetailsUnknownStore.tr();
    return trimmed;
  }

  String _address(String address) {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return LocaleKeys.orderDetailsNoAddress.tr();
    return trimmed;
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
