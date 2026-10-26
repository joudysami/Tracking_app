import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/order_card.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.extentAfter < 200) {
      context.read<HomeCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

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
        final messenger = ScaffoldMessenger.of(context);
        final claimError = state.claimOrderState.errorMessage;
        final ordersError = state.ordersState.errorMessage;

        if (claimError.isNotEmpty) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(claimError)));
        }

        if (ordersError.isNotEmpty) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(ordersError)));
        }

        if (claimError.isEmpty &&
            ordersError.isEmpty &&
            state.claimOrderState.data != null) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  LocaleKeys.homeOrderAccepted.tr(
                    namedArgs: {'id': state.claimOrderState.data!.orderId},
                  ),
                ),
              ),
            );

          context.push(AppRoutes.order, extra: state.claimOrderState.data);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              LocaleKeys.homeTitle.tr(),
              style: TextStyle(
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
                          color: context.colors.pink,
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
                              child: Text(LocaleKeys.commonRetry.tr()),
                            ),
                          ],
                        ),
                      );
                    }

                    final orders = ordersState.data ?? [];

                    if (orders.isEmpty) {
                      return Center(
                        child: Text(LocaleKeys.homeNoPendingOrders.tr()),
                      );
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
                        controller: _scrollController,
                        itemCount:
                            orders.length +
                            (state.pagination?.hasNextPage == true ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          if (index >= orders.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final order = orders[index];

                          return BlocSelector<
                            HomeCubit,
                            HomeState,
                            ({bool isClaiming, bool isDisabled})
                          >(
                            selector: (state) {
                              return (
                                isClaiming:
                                    state.claimingOrderId == order.orderId,
                                isDisabled: state.claimOrderState.isLoading,
                              );
                            },
                            builder: (context, claimStatus) {
                              return OrderCard(
                                orderId: order.orderId,
                                storeName: order.storeName,
                                storeAddress: order.storeAddress,
                                customerName: order.customerName,
                                customerAddress: order.customerAddress,
                                price: order.totalAmount.toStringAsFixed(2),
                                isClaiming: claimStatus.isClaiming,
                                isAcceptDisabled: claimStatus.isDisabled,
                                onAccept: () {
                                  if (claimStatus.isDisabled) return;

                                  context.read<HomeCubit>().doEvent(
                                    ClaimOrderEvent(orderId: order.orderId),
                                  );
                                  context.read<HomeCubit>().doEvent(
                                    const GetAvailableOrdersEvent(),
                                  );
                                  context.push(
                                    AppRoutes.order,
                                    extra: order,
                                  );
                                },
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
