import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/order/domain/enitiy/confirm_delivery_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';

class OrderState extends Equatable {
  final OrderDetailsEntity? order;
  final BaseState<OrderDetailsEntity> updateStatusState;
  final BaseState<ConfirmDeliveryEntity> confirmDeliveryState;

  const OrderState({
    this.order,
    this.updateStatusState = const BaseState(),
    this.confirmDeliveryState = const BaseState(),
  });

  bool get isActionLoading =>
      updateStatusState.isLoading || confirmDeliveryState.isLoading;

  OrderState copyWith({
    OrderDetailsEntity? order,
    BaseState<OrderDetailsEntity>? updateStatusState,
    BaseState<ConfirmDeliveryEntity>? confirmDeliveryState,
  }) {
    return OrderState(
      order: order ?? this.order,
      updateStatusState: updateStatusState ?? this.updateStatusState,
      confirmDeliveryState: confirmDeliveryState ?? this.confirmDeliveryState,
    );
  }

  @override
  List<Object?> get props => [order, updateStatusState, confirmDeliveryState];
}
