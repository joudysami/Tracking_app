sealed class OrderHistoryEvent {
  const OrderHistoryEvent();
}

class LoadOrderHistory extends OrderHistoryEvent {
  const LoadOrderHistory();
}

class LoadMoreOrderHistory extends OrderHistoryEvent {
  const LoadMoreOrderHistory();
}

class RefreshOrderHistory extends OrderHistoryEvent {
  const RefreshOrderHistory();
}

class RetryOrderHistory extends OrderHistoryEvent {
  const RetryOrderHistory();
}

class OpenOrderDetails extends OrderHistoryEvent {
  final String orderId;

  const OpenOrderDetails(this.orderId);
}

class RetryOrderCount extends OrderHistoryEvent {
  final String status;

  const RetryOrderCount(this.status);
}
