sealed class OrderEvent {
  const OrderEvent();
}

class InitializeOrderEvent extends OrderEvent {
  final Object? order;
  const InitializeOrderEvent(this.order);
}

class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String status;
  final String note;

  const UpdateOrderStatusEvent({
    required this.orderId,
    required this.status,
    this.note = '',
  });
}

class ConfirmOrderDeliveryEvent extends OrderEvent {
  final String orderId;

  const ConfirmOrderDeliveryEvent({required this.orderId});
}

class NextStatus extends OrderEvent {
  const NextStatus();
}
