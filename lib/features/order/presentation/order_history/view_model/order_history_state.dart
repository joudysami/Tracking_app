import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';

class OrderHistoryState extends Equatable {
  final List<OrderHistoryEntity> orders;
  final PaginationStatus status;
  final bool hasMore;
  final int currentPage;
  final int? completedCount;
  final int? cancelledCount;

  const OrderHistoryState({
    this.orders = const [],
    this.status = PaginationStatus.initial,
    this.hasMore = true,
    this.currentPage = 0,
    this.completedCount,
    this.cancelledCount,
  });

  OrderHistoryState copyWith({
    List<OrderHistoryEntity>? orders,
    PaginationStatus? status,
    bool? hasMore,
    int? currentPage,
    int? completedCount,
    int? cancelledCount,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      completedCount: completedCount ?? this.completedCount,
      cancelledCount: cancelledCount ?? this.cancelledCount,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    status,
    hasMore,
    currentPage,
    completedCount,
    cancelledCount,
  ];
}
