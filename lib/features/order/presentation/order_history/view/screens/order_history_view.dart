import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/core/base/base_view_model.dart';
import 'package:tracking_app/core/constant/widget_keys.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';
import 'package:tracking_app/core/widgets/app_shimmer/order_history_shimmer.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/orders_history_count.dart';

import '../../../../../../core/base/base_ui_event.dart';
import '../../../../../../core/mixin/ui_event_mixin.dart';
import '../../view_model/order_history_event.dart';
import '../../view_model/order_history_state.dart';
import '../../view_model/order_history_view_model.dart';
import '../widgets/load_more_order_history.dart';
import '../widgets/order_history_card.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView>
    with UiEventMixin<OrderHistoryView, OrderHistoryState, BaseUiEvent> {
  OrderHistoryViewModel get _vm => context.read<OrderHistoryViewModel>();

  @override
  BaseViewModel<OrderHistoryState, BaseUiEvent> get viewModel => _vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24.r),
        ),
        title: Text(LocaleKeys.ordersTitle.tr()),
      ),
      body: BlocBuilder<OrderHistoryViewModel, OrderHistoryState>(
        builder: (context, state) {
          final isFirstLoad =
              state.orders.isEmpty &&
              (state.status == PaginationStatus.initial ||
                  state.status == PaginationStatus.loading);

          if (isFirstLoad) {
            return const OrderHistoryShimmer(
              key: WidgetKeys.orderHistoryShimmer,
            );
          }

          if (state.status == PaginationStatus.error) {
            return Center(
              child: TextButton(
                key: WidgetKeys.orderHistoryErrorRetry,
                onPressed: () => _vm.onEvent(const RetryOrderHistory()),
                child: Text(LocaleKeys.commonRetry.tr()),
              ),
            );
          }

          if (state.orders.isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.ordersNoOrders.tr(),
                key: WidgetKeys.orderHistoryEmpty,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _vm.onEvent(const RefreshOrderHistory()),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16.r),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrdersHistoryCount(
                          completedCount: state.completedCount,
                          cancelledCount: state.cancelledCount,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          LocaleKeys.recentOrders.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList.separated(
                    itemCount: state.orders.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (_, i) {
                      final order = state.orders[i];
                      final id = order.id;
                      return OrderHistoryCard(
                        order: order,
                        onTap: id == null
                            ? null
                            : () => _vm.onEvent(OpenOrderDetails(id)),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: OrderHistoryLoadMoreFooter(
                      state: state,
                      onLoadMore: () =>
                          _vm.onEvent(const LoadMoreOrderHistory()),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
