import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/order/core/order_status_progress.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_event.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_state.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_view_model.dart';

import '../widgets/order_details_body.dart';

bool _awaitsCustomerConfirmation(String? status) {
  return normalizeOrderStatus(status ?? '') == 'awaiting_delivery_confirmation';
}

class OrderDetailsScreen extends StatelessWidget {
  final Object? order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderViewModel, OrderState>(
      listenWhen: (previous, current) {
        final reachedAwaitingConfirmation =
            previous.order != null &&
            !_awaitsCustomerConfirmation(previous.order!.status) &&
            _awaitsCustomerConfirmation(current.order?.status);

        return previous.updateStatusState.errorMessage !=
                current.updateStatusState.errorMessage ||
            previous.confirmDeliveryState.errorMessage !=
                current.confirmDeliveryState.errorMessage ||
            previous.locationReportState.errorMessage !=
                current.locationReportState.errorMessage ||
            current.activeOrderMissing ||
            reachedAwaitingConfirmation;
      },
      listener: (context, state) {
        final error = state.updateStatusState.errorMessage.isNotEmpty
            ? state.updateStatusState.errorMessage
            : state.locationReportState.errorMessage.isNotEmpty
            ? state.locationReportState.errorMessage
            : state.confirmDeliveryState.errorMessage;

        if (error.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));

          if (state.activeOrderMissing) context.pop(true);
        } else if (_awaitsCustomerConfirmation(state.order?.status)) {
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  LocaleKeys.orderDetailsAwaitingCustomerConfirmation.tr(),
                ),
              ),
            );
          context.push(AppRoutes.orderSuccess).then((_) {
            if (context.mounted) context.pop(true);
          });
        }
      },
      builder: (context, state) {
        final orderDetails = state.order;

        final isLoading = state.isActionLoading;

        final actionKey = orderDetails == null
            ? null
            : getOrderActionLabelKey(orderDetails.status);
        final canAdvance =
            orderDetails != null &&
            getNextOrderStatus(orderDetails.status) != null;
        return Scaffold(
          backgroundColor: context.colors.white,
          appBar: AppBar(title: Text(LocaleKeys.orderDetailsTitle.tr())),
          body: orderDetails == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      LocaleKeys.orderDetailsUnavailable.tr(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : OrderDetailsBody(
                  order: orderDetails,
                  scrollController: PrimaryScrollController.of(context),
                ),
          bottomNavigationBar: actionKey == null
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (isLoading || !canAdvance)
                            ? null
                            : () {
                                context.read<OrderViewModel>().doEvent(
                                  const NextStatus(),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canAdvance
                              ? context.colors.pink
                              : context.colors.disabledButton,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: context.colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                actionKey.tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
