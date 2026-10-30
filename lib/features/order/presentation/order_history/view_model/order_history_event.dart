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
