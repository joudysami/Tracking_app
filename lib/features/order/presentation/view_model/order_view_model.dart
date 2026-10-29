import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';
import 'package:tracking_app/features/order/domain/order_status_progress.dart';
import 'package:tracking_app/features/order/domain/use_case/confirm_delivery_usecase.dart';
import 'package:tracking_app/features/order/domain/use_case/order_status_use_case.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_event.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_state.dart';

@injectable
class OrderViewModel extends Cubit<OrderState> {
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final ConfirmDeliveryUseCase confirmDeliveryUseCase;

  OrderViewModel({
    required this.updateOrderStatusUseCase,
    required this.confirmDeliveryUseCase,
  }) : super(const OrderState());

  void doEvent(OrderEvent event) {
    switch (event) {
      // case InitializeOrderEvent():
      //   _initializeOrder(event.order);
      //   break;
      case UpdateOrderStatusEvent():
        _updateStatus(
          orderId: event.orderId,
          status: event.status,
          note: event.note,
        );
        break;
      case ConfirmOrderDeliveryEvent():
        _confirmDelivery(event.orderId);
        break;
      case NextStatus():
        _nextStatus();
        break;
    }
  }

  // void _initializeOrder(Object? raw) {
  //   if (raw is OrderDetailsEntity) {
  //     emit(state.copyWith(order: raw));
  //   } else if (raw is AvailableOrderEntity) {
  //     emit(state.copyWith(order: OrderDetailsEntity.fromAvailableOrder(raw)));
  //   } else if (raw is ClaimedOrderEntity) {
  //     emit(state.copyWith(order: OrderDetailsEntity.fromClaimedOrder(raw)));
  //   }
  // }

  Future<void> _nextStatus() async {
    final currentOrder = state.order;
    if (currentOrder == null || state.isActionLoading) return;

    final normalized = normalizeOrderStatus(currentOrder.status);
    if (normalized == 'arrived' ||
        normalized == 'awaiting_delivery_confirmation') {
      await _confirmDelivery(currentOrder.orderId);
      return;
    }

    final nextStatus = getNextOrderStatus(currentOrder.status);
    if (nextStatus != null) {
      await _updateStatus(
        orderId: currentOrder.orderId,
        status: nextStatus,
        note: 'Status updated to $nextStatus',
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
