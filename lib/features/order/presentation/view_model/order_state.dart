import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/confirm_delivery_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';

class OrderState extends Equatable {
  final OrderDetailsEntity? order;
  final BaseState<OrderDetailsEntity> updateStatusState;
  final BaseState<ConfirmDeliveryEntity> confirmDeliveryState;
  final BaseState<LocationReportEntity> locationReportState;

  const OrderState({
    this.order,
    this.updateStatusState = const BaseState(),
    this.confirmDeliveryState = const BaseState(),
    this.locationReportState = const BaseState(),
  });

  bool get isActionLoading =>
      updateStatusState.isLoading ||
      confirmDeliveryState.isLoading ||
      locationReportState.isLoading;

  OrderState copyWith({
    OrderDetailsEntity? order,
    BaseState<OrderDetailsEntity>? updateStatusState,
    BaseState<ConfirmDeliveryEntity>? confirmDeliveryState,
    BaseState<LocationReportEntity>? locationReportState,
  }) {
    return OrderState(
      order: order ?? this.order,
      updateStatusState: updateStatusState ?? this.updateStatusState,
      confirmDeliveryState: confirmDeliveryState ?? this.confirmDeliveryState,
      locationReportState: locationReportState ?? this.locationReportState,
    );
  }

  @override
  List<Object?> get props => [
    order,
    updateStatusState,
    confirmDeliveryState,
    locationReportState,
  ];
}
