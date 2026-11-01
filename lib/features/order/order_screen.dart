import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/order_card.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/features/order/presentation/screen/order_details_screen.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_event.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_view_model.dart';
import 'package:tracking_app/features/order/presentation/widgets/order_status_card.dart';

class OrderScreen extends StatelessWidget {
  final Object? order;

  const OrderScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.white,
      appBar: AppBar(
        title: Text(
          LocaleKeys.ordersTitle.tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.colors.pink,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final activeOrder = state.claimOrderState.data;

          if (activeOrder == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: context.colors.pink.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.ordersNoOrders.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                  ),
                  if (order != null) ...[
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => getIt<OrderViewModel>()
                                ..doEvent(InitializeOrderEvent(order)),
                              child: OrderDetailsScreen(order: order),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.pink,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(LocaleKeys.orderDetailsTitle.tr()),
                    ),
                  ],
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [_activeOrderCard(context, activeOrder)],
          );
        },
      ),
    );
  }

  /// Reuses the home cards as they are: the full order card once the
  /// assigned-order endpoint supplied its details, the status card before that.
  Widget _activeOrderCard(BuildContext context, ClaimedOrderEntity order) {
    final orderId = order.orderNumber.isEmpty
        ? order.orderId
        : order.orderNumber;

    final card = !order.hasDetails
        ? OrderStatusCard(
            status: order.status,
            orderId: orderId,
            createdAt: order.assignedAt,
          )
        : OrderCard(
            orderId: orderId,
            storeName: order.storeName,
            storeAddress: order.storeAddress,
            customerName: order.customerName,
            customerAddress: order.customerAddress,
            price: order.totalAmount.toStringAsFixed(2),
            isAcceptDisabled: true,
            onAccept: () => _openOrderDetails(context, order),
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openOrderDetails(context, order),
      child: card,
    );
  }

  void _openOrderDetails(BuildContext context, ClaimedOrderEntity order) {
    context.push<bool>(AppRoutes.orderDetails, extra: order).then((finished) {
      if (finished == true && context.mounted) {
        context.read<HomeCubit>().doEvent(const ActiveOrderDelivered());
      }
    });
  }
}
