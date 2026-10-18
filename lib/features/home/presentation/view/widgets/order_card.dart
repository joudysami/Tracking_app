import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
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
  final VoidCallback? onOpen;
  final bool isClaiming;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.storeName,
    required this.storeAddress,
    required this.customerName,
    required this.customerAddress,
    required this.price,
    required this.onAccept,
    this.onOpen,
    this.isClaiming = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEBEBEB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.homeFlowerOrder.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                LocaleKeys.homePickupAddress.tr(),
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
              const SizedBox(height: 4),

              AddressTile(
                title: storeName,
                address: storeAddress,
                isStore: true,
              ),

              const SizedBox(height: 8),

              Text(
                LocaleKeys.homeUserAddress.tr(),
                style: const TextStyle(fontSize: 9, color: Colors.grey),
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
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AcceptButton(onPressed: onAccept, isLoading: isClaiming),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
