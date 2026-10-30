import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_view_model.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../../../core/base/base_ui_event.dart';
import '../../../data/api/order_status_api_values.dart';
import '../../../domain/entities/order_history_entity.dart';
import '../../../domain/use_cases/get_order_count_use_case.dart';
import '../../../domain/use_cases/get_orders_history_use_case.dart';
import 'order_history_event.dart';
import 'order_history_state.dart';

@Injectable()
class OrderHistoryViewModel
    extends BaseViewModel<OrderHistoryState, BaseUiEvent> {
  final GetOrdersHistoryUseCase _getOrdersHistory;
  final GetOrdersCountUseCase _getOrdersCount;

  static const int _pageSize = 10;
  static const int _maxEmptyPageSkips = 10;
  int _emptyPageSkips = 0;
  bool _isRequestInProgress = false;

  OrderHistoryViewModel(this._getOrdersHistory, this._getOrdersCount)
    : super(const OrderHistoryState());

  Future<void> onEvent(OrderHistoryEvent event) {
    return switch (event) {
      LoadOrderHistory() => Future.wait([_load(), _loadCounts()]),
      RefreshOrderHistory() => Future.wait([
        _load(refresh: true),
        _loadCounts(),
      ]),
      LoadMoreOrderHistory() || RetryOrderHistory() => _load(),
      OpenOrderDetails(:final orderId) => _openDetails(orderId),
    };
  }

  Future<void> _openDetails(String orderId) async {
    emitEvent(NavigateEvent(AppRoutes.orderDetailsHistory, arguments: orderId));
  }

  Future<void> _load({bool refresh = false}) async {
    if (_isRequestInProgress) return;
    if (!refresh && !state.hasMore) return;

    _isRequestInProgress = true;

    final isFirstPage = refresh || state.currentPage == 0;
    final page = isFirstPage ? 1 : state.currentPage + 1;
    if (isFirstPage) _emptyPageSkips = 0;

    emit(
      refresh
          ? state.copyWith(
              orders: const [],
              hasMore: true,
              currentPage: 0,
              status: PaginationStatus.loading,
            )
          : state.copyWith(
              status: isFirstPage
                  ? PaginationStatus.loading
                  : PaginationStatus.loadingMore,
            ),
    );

    final response = await _getOrdersHistory(page: page, pageSize: _pageSize);
    _isRequestInProgress = false;
    if (isClosed) return;

    switch (response) {
      case SuccessResponse(:final data):
        final items = data?.items ?? const <OrderHistoryEntity>[];
        final hasMore = data?.pagination.hasNextPage ?? false;

        emit(
          state.copyWith(
            orders: [...state.orders, ...items],
            status: PaginationStatus.success,
            hasMore: hasMore,
            currentPage: page,
          ),
        );

        if (items.isNotEmpty) _emptyPageSkips = 0;
        if (items.isEmpty && hasMore && _emptyPageSkips < _maxEmptyPageSkips) {
          _emptyPageSkips++;
          await _load();
        }

      case ErrorResponse(:final appError):
        emit(
          state.copyWith(
            status: isFirstPage
                ? PaginationStatus.error
                : PaginationStatus.errorLoadingMore,
          ),
        );
        emitError(appError);
    }
  }

  Future<void> _loadCounts() async {
    final results = await Future.wait([
      _getOrdersCount(status: OrderStatusApiValues.delivered),
      _getOrdersCount(status: OrderStatusApiValues.cancelled),
    ]);
    if (isClosed) return;

    emit(
      state.copyWith(
        completedCount: switch (results[0]) {
          SuccessResponse(:final data) => data,
          ErrorResponse() => null,
        },
        cancelledCount: switch (results[1]) {
          SuccessResponse(:final data) => data,
          ErrorResponse() => null,
        },
      ),
    );
  }
}
