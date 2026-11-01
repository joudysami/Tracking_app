sealed class HomeEvent {
  const HomeEvent();
}

class GetAvailableOrdersEvent extends HomeEvent {
  final int page;
  final int pageSize;

  const GetAvailableOrdersEvent({this.page = 1, this.pageSize = 20});
}

class GetAssignedOrderEvent extends HomeEvent {
  const GetAssignedOrderEvent();
}

class ClaimOrderEvent extends HomeEvent {
  final String orderId;

  const ClaimOrderEvent({required this.orderId});
}

/// The driver finished the order they were holding, so the app can forget it
/// and Accept becomes available again.
class ActiveOrderDelivered extends HomeEvent {
  const ActiveOrderDelivered();
}
