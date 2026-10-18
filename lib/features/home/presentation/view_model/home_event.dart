
sealed class HomeEvent {
  const HomeEvent();
}

class GetAvailableOrdersEvent extends HomeEvent {
  final int page;
  final int pageSize;

  const GetAvailableOrdersEvent({
    this.page = 1,
    this.pageSize = 20,
  });
}

class ClaimOrderEvent extends HomeEvent {
  final String orderId;

  const ClaimOrderEvent({required this.orderId});
}
