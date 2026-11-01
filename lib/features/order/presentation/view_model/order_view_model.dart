import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_reporting_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_tracking_use_case.dart';
import 'package:tracking_app/features/order/core/order_status_progress.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';
import 'package:tracking_app/features/order/domain/use_case/confirm_delivery_usecase.dart';
import 'package:tracking_app/features/order/domain/use_case/order_status_use_case.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_event.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_state.dart';

@injectable
class OrderViewModel extends Cubit<OrderState> {
  /// How long the driver may have to wait for a GPS fix before the location
  /// report is given up on; the stage transition itself is never held back.
  static const Duration _locationFixTimeout = Duration(seconds: 15);

  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final ConfirmDeliveryUseCase confirmDeliveryUseCase;
  final LocationReportingUseCase locationReportingUseCase;
  final LocationTrackingUseCase locationTrackingUseCase;

  OrderViewModel({
    required this.updateOrderStatusUseCase,
    required this.confirmDeliveryUseCase,
    required this.locationReportingUseCase,
    required this.locationTrackingUseCase,
  }) : super(const OrderState());

  void doEvent(OrderEvent event) {
    switch (event) {
      case InitializeOrderEvent():
        _initializeOrder(event.order);
      case UpdateOrderStatusEvent():
        _updateStatus(
          orderId: event.orderId,
          status: event.status,
          note: event.note,
        );
      case ConfirmOrderDeliveryEvent():
        _confirmDelivery(event.orderId);
      case NextStatus():
        _nextStatus();
    }
  }

  /// Converts the raw route extra (any order entity type) into
  /// [OrderDetailsEntity] and stores it in [state.order] so that
  /// [_nextStatus] always has a non-null order to work with.
  void _initializeOrder(Object? raw) {
    if (raw is OrderDetailsEntity) {
      emit(state.copyWith(order: raw));
    } else if (raw is AvailableOrderEntity) {
      emit(state.copyWith(order: OrderDetailsEntity.fromAvailableOrder(raw)));
    } else if (raw is ClaimedOrderEntity) {
      emit(state.copyWith(order: OrderDetailsEntity.fromClaimedOrder(raw)));
    }
  }

  Future<void> _nextStatus() async {
    final currentOrder = state.order;
    if (currentOrder == null || state.isActionLoading) return;

    // Every driver stage, the last one included, goes through the status
    // endpoint: the backend's confirm-delivery endpoint is the customer's.
    final nextStatus = getNextOrderStatus(currentOrder.status);
    if (nextStatus == null) return;

    await _updateStatus(
      orderId: currentOrder.orderId,
      status: nextStatus,
      note: 'Status updated to $nextStatus',
    );

    // The backend only accepts a driver-location report while the order is
    // out for delivery, so the location is reported after the status call
    // and can never hold the stage back.
    final newStatus = normalizeOrderStatus(state.order?.status ?? '');
    if (newStatus == 'out_for_delivery') {
      await _reportDriverLocation();
    }
  }

  /// Best effort driver-location report. A null result from the use case
  /// means the driver barely moved (nothing to report) and is not an error.
  /// Failures only surface a message; they never block the stage transition.
  Future<void> _reportDriverLocation() async {
    try {
      // GPS can stay unfixed (permission denied, service off, no signal), so
      // the wait is bounded and the stage the driver just reached stands.
      final location = await locationTrackingUseCase().first.timeout(
        _locationFixTimeout,
      );
      final result = await locationReportingUseCase(location);

      if (isClosed) return;

      switch (result) {
        case null:
        case SuccessResponse<LocationReportEntity>():
          emit(
            state.copyWith(
              locationReportState: state.locationReportState.copyWith(
                errorMessage: '',
              ),
            ),
          );

        case ErrorResponse<LocationReportEntity>(:final appError):
          emit(
            state.copyWith(
              locationReportState: state.locationReportState.copyWith(
                errorMessage: appError.message,
              ),
            ),
          );
      }
    } on TimeoutException {
      if (isClosed) return;

      emit(
        state.copyWith(
          locationReportState: state.locationReportState.copyWith(
            errorMessage: LocaleKeys.locationFixTimedOut.tr(),
          ),
        ),
      );
    } catch (_) {
      if (isClosed) return;

      emit(
        state.copyWith(
          locationReportState: state.locationReportState.copyWith(
            errorMessage: LocaleKeys.locationReportFailed.tr(),
          ),
        ),
      );
    }
  }

  Future<void> _updateStatus({
    required String orderId,
    required String status,
    required String note,
  }) async {
    if (state.isActionLoading) return;

    emit(
      state.copyWith(
        updateStatusState: state.updateStatusState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final result = await updateOrderStatusUseCase(
      orderId: orderId,
      status: status,
      note: note,
    );

    switch (result) {
      case SuccessResponse():
        final current = state.order;
        final updated =
            (current ??
                    OrderDetailsEntity(
                      orderId: orderId,
                      orderNumber: orderId,
                      status: status,
                      createdAt: DateTime.now().toIso8601String(),
                      customerName: '',
                      customerAddress: '',
                      storeName: '',
                      storeAddress: '',
                      totalAmount: 0,
                      paymentMethod: '',
                      items: const [],
                    ))
                .copyWith(status: status);

        emit(
          state.copyWith(
            order: updated,
            updateStatusState: state.updateStatusState.copyWith(
              isLoading: false,
              errorMessage: '',
              data: updated,
            ),
          ),
        );

      case ErrorResponse(appError: final appError):
        emit(
          state.copyWith(
            activeOrderMissing: appError is NotFoundError,
            updateStatusState: state.updateStatusState.copyWith(
              isLoading: false,
              errorMessage: appError.message,
            ),
          ),
        );
    }
  }

  Future<void> _confirmDelivery(String orderId) async {
    if (state.isActionLoading) return;

    emit(
      state.copyWith(
        confirmDeliveryState: state.confirmDeliveryState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final result = await confirmDeliveryUseCase(orderId: orderId);

    switch (result) {
      case SuccessResponse(data: final data):
        final updated = state.order?.copyWith(status: 'delivered');
        emit(
          state.copyWith(
            order: updated,
            confirmDeliveryState: state.confirmDeliveryState.copyWith(
              isLoading: false,
              errorMessage: '',
              data: data,
            ),
          ),
        );

      case ErrorResponse(appError: final appError):
        emit(
          state.copyWith(
            confirmDeliveryState: state.confirmDeliveryState.copyWith(
              isLoading: false,
              errorMessage: appError.message,
            ),
          ),
        );
    }
  }
}
