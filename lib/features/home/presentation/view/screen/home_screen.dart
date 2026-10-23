import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/order_card.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        final claimError = state.claimOrderState.errorMessage;
        final ordersError = state.ordersState.errorMessage;
        if (claimError.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(claimError)));
        } else if (ordersError.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(ordersError)));
        } else if (state.claimOrderState.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                LocaleKeys.homeOrderAccepted.tr(
                  namedArgs: {'id': state.claimOrderState.data!.orderId},
                ),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              LocaleKeys.homeTitle.tr(),
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.colors.pink,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final ordersState = state.ordersState;

                    if (ordersState.isLoading && ordersState.data == null) {
                      return Center(
                        child: CircularProgressIndicator(
                          color:context.colors.pink,
                        ),
                      );
                    }

                    if (ordersState.errorMessage.isNotEmpty &&
                        ordersState.data == null) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(ordersState.errorMessage),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                context.read<HomeCubit>().doEvent(
                                  const GetAvailableOrdersEvent(),
                                );
                              },
                              child: Text(LocaleKeys.commonRetry.tr(),
                            ),
                            ),
                          ],
                        ),
                      );
                    }

                    final orders = ordersState.data ?? [];

                    if (orders.isEmpty) {
                      return Center(child: Text(LocaleKeys.homeNoPendingOrders.tr()));
                    }
                    return RefreshIndicator(
                      color: context.colors.pink,
                      onRefresh: () async {
                        context.read<HomeCubit>().doEvent(
                          const GetAvailableOrdersEvent(),
                        );
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final order = orders[index];

                          return OrderCard(
                            orderId: order.orderId,
                            storeName: order.storeName,
                            storeAddress: order.storeAddress,
                            customerName: order.customerName,
                            customerAddress: order.customerAddress,
                            price: order.totalAmount.toStringAsFixed(2),
                            isClaiming:
                                state.claimOrderState.isLoading &&
                                state.claimOrderState.data == null,
                            onAccept: () {
                              context.read<HomeCubit>().doEvent(
                                ClaimOrderEvent(orderId: order.orderId),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
