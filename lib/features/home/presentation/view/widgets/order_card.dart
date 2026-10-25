import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/accept_button.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/address_tile.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String storeName;
  final String storeAddress;
  final String customerName;
  final String customerAddress;
  final String price;
  final VoidCallback onAccept;
  final bool isClaiming;
  final bool isAcceptDisabled;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.storeName,
    required this.storeAddress,
    required this.customerName,
    required this.customerAddress,
    required this.price,
    required this.onAccept,
    this.isClaiming = false,
    this.isAcceptDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.homeFlowerOrder.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colors.black.shade50,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            LocaleKeys.homePickupAddress.tr(),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),

          AddressTile(title: storeName, address: storeAddress, isStore: true),

          const SizedBox(height: 8),

          Text(
            LocaleKeys.homeUserAddress.tr(),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),

          AddressTile(title: customerName, address: customerAddress),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.homePrice.tr(namedArgs: {'price': price}),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AcceptButton(
                onPressed: onAccept,
                isLoading: isClaiming,
                isDisabled: isAcceptDisabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
