import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';

import 'package:tracking_app/features/home/presentation/view/widgets/order_card.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) {
        final claimError = current.claimOrderState.errorMessage;
        final claimSuccess = current.claimOrderState.data;
        final ordersError = current.ordersState.errorMessage;
        final newClaimError =
            claimError.isNotEmpty &&
            claimError != previous.claimOrderState.errorMessage;
        final newClaimSuccess =
            claimSuccess != null &&
            claimSuccess.orderId != previous.claimOrderState.data?.orderId;
        final newOrdersError =
            ordersError.isNotEmpty &&
            ordersError != previous.ordersState.errorMessage;
        return newClaimError || newClaimSuccess || newOrdersError;
      },
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
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          title: Text(
            LocaleKeys.homeTitle.tr(),
            style: const TextStyle(fontSize: 14),
          ),
          backgroundColor: const Color(0xFFF8F8F8),
          foregroundColor: const Color(0xFF555555),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  LocaleKeys.homeBrand.tr(),
                  style: const TextStyle(
                    color: Color(0xFFD51D72),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'serif',
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final ordersState = state.ordersState;

                    if (ordersState.isLoading && ordersState.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD51D72),
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
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final orders = ordersState.data ?? [];

                    if (orders.isEmpty) {
                      return const Center(child: Text('No available orders'));
                    }

                    return RefreshIndicator(
                      color: const Color(0xFFD51D72),
                      onRefresh: () {
                        return context.read<HomeCubit>().doEvent(
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
                            isClaiming: state.claimingOrderId == order.orderId,
                            onOpen: () {
                              context.push(
                                AppRoutes.orderDetails,
                                extra: order,
                              );
                            },
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
