import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';

class OrderCountState extends Equatable {
  final int? value;
  final bool loading;
  final bool failed;

  const OrderCountState({
    this.value,
    this.loading = false,
    this.failed = false,
  });

  @override
  List<Object?> get props => [value, loading, failed];
}

class OrderHistoryState extends Equatable {
  final List<OrderHistoryEntity> orders;
  final PaginationStatus status;
  final bool hasMore;
  final int currentPage;
  final OrderCountState completed;
  final OrderCountState cancelled;

  const OrderHistoryState({
    this.orders = const [],
    this.status = PaginationStatus.initial,
    this.hasMore = true,
    this.currentPage = 0,
    this.completed = const OrderCountState(),
    this.cancelled = const OrderCountState(),
  });

  OrderHistoryState copyWith({
    List<OrderHistoryEntity>? orders,
    PaginationStatus? status,
    bool? hasMore,
    int? currentPage,
    OrderCountState? completed,
    OrderCountState? cancelled,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    status,
    hasMore,
    currentPage,
    completed,
    cancelled,
  ];
}
