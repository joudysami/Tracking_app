import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_ui_event.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/utils/pagination/paginated_result.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';
import 'package:tracking_app/features/order/data/api/order_status_api_values.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/order/domain/entities/pagination_params.dart';
import 'package:tracking_app/features/order/domain/use_cases/get_order_count_use_case.dart';
import 'package:tracking_app/features/order/domain/use_cases/get_orders_history_use_case.dart';
import 'package:tracking_app/features/order/presentation/order_history/view_model/order_history_event.dart';
import 'package:tracking_app/features/order/presentation/order_history/view_model/order_history_view_model.dart';

import 'order_history_view_model_test.mocks.dart';

@GenerateMocks([GetOrdersHistoryUseCase, GetOrdersCountUseCase])
void main() {
  provideDummy<BaseResponse<PaginatedResult<OrderHistoryEntity>>>(
    const SuccessResponse<PaginatedResult<OrderHistoryEntity>>(
      PaginatedResult(items: [], pagination: PaginationParams()),
    ),
  );
  provideDummy<BaseResponse<int?>>(const SuccessResponse<int?>(0));
  provideDummy<String>(OrderStatusApiValues.delivered);
  provideDummy<int>(0);

  late MockGetOrdersHistoryUseCase history;
  late MockGetOrdersCountUseCase count;
  late OrderHistoryViewModel viewModel;

  setUp(() {
    history = MockGetOrdersHistoryUseCase();
    count = MockGetOrdersCountUseCase();
    viewModel = OrderHistoryViewModel(history, count);
    when(
      count.call(status: anyNamed('status')),
    ).thenAnswer((_) async => const SuccessResponse<int?>(5));
  });

  tearDown(() async {
    await viewModel.close();
  });

  void stubHistoryPage(
    int page,
    List<OrderHistoryEntity> items,
    bool hasNextPage,
  ) {
    when(history.call(page: page, pageSize: 10)).thenAnswer(
      (_) async => SuccessResponse(
        PaginatedResult(
          items: items,
          pagination: PaginationParams(hasNextPage: hasNextPage),
        ),
      ),
    );
  }

  group('OrderHistoryViewModel', () {
    test('loads the first page and fills counts', () async {
      stubHistoryPage(1, const [
        OrderHistoryEntity(id: '1', status: OrderStatusApiValues.delivered),
      ], false);

      await viewModel.onEvent(const LoadOrderHistory());

      expect(viewModel.state.orders.length, 1);
      expect(viewModel.state.status, PaginationStatus.success);
      expect(viewModel.state.currentPage, 1);
      expect(viewModel.state.hasMore, isFalse);
      expect(viewModel.state.completedCount, 5);
      expect(viewModel.state.cancelledCount, 5);
    });

    test('appends the next page on load more', () async {
      stubHistoryPage(1, const [OrderHistoryEntity(id: '1')], true);
      stubHistoryPage(2, const [OrderHistoryEntity(id: '2')], false);

      await viewModel.onEvent(const LoadOrderHistory());
      await viewModel.onEvent(const LoadMoreOrderHistory());

      expect(viewModel.state.orders.map((e) => e.id), ['1', '2']);
      expect(viewModel.state.currentPage, 2);
      expect(viewModel.state.hasMore, isFalse);
    });

    test('skips an empty page while hasMore and stops when filled', () async {
      stubHistoryPage(1, const [], true);
      stubHistoryPage(2, const [OrderHistoryEntity(id: '2')], false);

      await viewModel.onEvent(const LoadOrderHistory());

      expect(viewModel.state.orders.map((e) => e.id), ['2']);
      expect(viewModel.state.currentPage, 2);
      verify(history.call(page: 2, pageSize: 10)).called(1);
    });

    test(
      'finishes empty when the only page has no history and no more',
      () async {
        stubHistoryPage(1, const [], false);

        await viewModel.onEvent(const LoadOrderHistory());

        expect(viewModel.state.orders, isEmpty);
        expect(viewModel.state.status, PaginationStatus.success);
        expect(viewModel.state.hasMore, isFalse);
      },
    );

    test('enters error status when the first page fails', () async {
      when(history.call(page: 1, pageSize: 10)).thenAnswer(
        (_) async => ErrorResponse<PaginatedResult<OrderHistoryEntity>>(
          appError: BadResponseError('down'),
        ),
      );

      await viewModel.onEvent(const LoadOrderHistory());

      expect(viewModel.state.status, PaginationStatus.error);
    });

    test('recovers from error through retry', () async {
      when(history.call(page: 1, pageSize: 10)).thenAnswer(
        (_) async => ErrorResponse<PaginatedResult<OrderHistoryEntity>>(
          appError: BadResponseError('down'),
        ),
      );
      await viewModel.onEvent(const RetryOrderHistory());
      expect(viewModel.state.status, PaginationStatus.error);

      stubHistoryPage(1, const [OrderHistoryEntity(id: '1')], false);
      await viewModel.onEvent(const RetryOrderHistory());

      expect(viewModel.state.status, PaginationStatus.success);
      expect(viewModel.state.orders.length, 1);
    });

    test('refresh resets the list and reloads page one', () async {
      stubHistoryPage(1, const [OrderHistoryEntity(id: '1')], true);
      await viewModel.onEvent(const LoadOrderHistory());

      stubHistoryPage(1, const [
        OrderHistoryEntity(id: '9'),
        OrderHistoryEntity(id: '8'),
      ], false);
      await viewModel.onEvent(const RefreshOrderHistory());

      expect(viewModel.state.orders.map((e) => e.id), ['9', '8']);
      expect(viewModel.state.currentPage, 1);
      expect(viewModel.state.hasMore, isFalse);
    });

    test('runs a refresh requested while a load is in flight', () async {
      final gate =
          Completer<BaseResponse<PaginatedResult<OrderHistoryEntity>>>();
      when(history.call(page: 1, pageSize: 10)).thenAnswer((_) => gate.future);

      final loading = viewModel.onEvent(const LoadOrderHistory());
      await viewModel.onEvent(const RefreshOrderHistory());

      gate.complete(
        SuccessResponse(
          PaginatedResult(
            items: const [OrderHistoryEntity(id: '7')],
            pagination: PaginationParams(hasNextPage: false),
          ),
        ),
      );
      await loading;

      verify(history.call(page: 1, pageSize: 10)).called(2);
      expect(viewModel.state.orders.map((e) => e.id), ['7']);
      expect(viewModel.state.status, PaginationStatus.success);
    });

    test('does not request when hasMore is false', () async {
      stubHistoryPage(1, const [OrderHistoryEntity(id: '1')], false);
      await viewModel.onEvent(const LoadOrderHistory());

      await viewModel.onEvent(const LoadMoreOrderHistory());

      verify(
        history.call(page: anyNamed('page'), pageSize: anyNamed('pageSize')),
      ).called(1);
    });

    test('emits navigate event to the history details route', () async {
      final pending = viewModel.eventStream.first;

      await viewModel.onEvent(const OpenOrderDetails('7'));

      final event = await pending;
      expect(event, isA<NavigateEvent>());
      expect((event as NavigateEvent).route, AppRoutes.orderDetailsHistory);
      expect(event.arguments, '7');
    });
  });
}
