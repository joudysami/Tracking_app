import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/constant/widget_keys.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/utils/pagination/paginated_result.dart';
import 'package:tracking_app/core/widgets/app_shimmer/order_history_shimmer.dart';
import 'package:tracking_app/features/order/data/api/order_status_api_values.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/order/domain/entities/pagination_params.dart';
import 'package:tracking_app/features/order/domain/use_cases/get_order_count_use_case.dart';
import 'package:tracking_app/features/order/domain/use_cases/get_orders_history_use_case.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/screens/order_history_view.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/load_more_order_history.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/order_history_card.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/orders_history_count.dart';
import 'package:tracking_app/features/order/presentation/order_history/view_model/order_history_event.dart';
import 'package:tracking_app/features/order/presentation/order_history/view_model/order_history_view_model.dart';

import '../../../../../../support/test_localization.dart';
import 'order_history_view_test.mocks.dart';

@GenerateMocks([GetOrdersHistoryUseCase, GetOrdersCountUseCase])
void main() {
  provideDummy<String>(OrderStatusApiValues.delivered);
  provideDummy<BaseResponse<int?>>(const SuccessResponse<int?>(0));
  provideDummy<BaseResponse<PaginatedResult<OrderHistoryEntity>>>(
    const SuccessResponse<PaginatedResult<OrderHistoryEntity>>(null),
  );

  setUpAll(loadEnglishTranslations);

  late MockGetOrdersHistoryUseCase history;
  late MockGetOrdersCountUseCase count;

  setUp(() {
    history = MockGetOrdersHistoryUseCase();
    count = MockGetOrdersCountUseCase();
    when(
      count.call(status: anyNamed('status')),
    ).thenAnswer((_) async => const SuccessResponse<int?>(2));
  });

  OrderHistoryViewModel buildViewModel() =>
      OrderHistoryViewModel(history, count);

  Future<void> pumpView(
    WidgetTester tester,
    OrderHistoryViewModel viewModel,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          home: BlocProvider.value(
            value: viewModel,
            child: const OrderHistoryView(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  void stubFirstPage(List<OrderHistoryEntity> items, bool hasNextPage) {
    when(history.call(page: 1, pageSize: 10)).thenAnswer(
      (_) async => SuccessResponse(
        PaginatedResult(
          items: items,
          pagination: PaginationParams(hasNextPage: hasNextPage),
        ),
      ),
    );
  }

  testWidgets('shows the shimmer placeholder on first load', (tester) async {
    final viewModel = buildViewModel();
    addTearDown(viewModel.close);

    await pumpView(tester, viewModel);

    expect(find.byKey(WidgetKeys.orderHistoryShimmer), findsOneWidget);
    expect(find.byType(OrderHistoryShimmer), findsOneWidget);
  });

  testWidgets('shows retry when the first page fails', (tester) async {
    when(history.call(page: 1, pageSize: 10)).thenAnswer(
      (_) async => ErrorResponse<PaginatedResult<OrderHistoryEntity>>(
        appError: BadResponseError('down'),
      ),
    );
    final viewModel = buildViewModel();
    addTearDown(viewModel.close);
    await viewModel.onEvent(const LoadOrderHistory());

    await pumpView(tester, viewModel);

    expect(find.byKey(WidgetKeys.orderHistoryErrorRetry), findsOneWidget);
  });

  testWidgets('shows the empty message when there are no orders', (
    tester,
  ) async {
    stubFirstPage(const [], false);
    final viewModel = buildViewModel();
    addTearDown(viewModel.close);
    await viewModel.onEvent(const LoadOrderHistory());

    await pumpView(tester, viewModel);

    expect(find.byKey(WidgetKeys.orderHistoryEmpty), findsOneWidget);
  });

  testWidgets('renders cards and the summary header for loaded orders', (
    tester,
  ) async {
    stubFirstPage(const [
      OrderHistoryEntity(
        id: '1',
        orderNumber: '#1',
        status: OrderStatusApiValues.delivered,
      ),
      OrderHistoryEntity(
        id: '2',
        orderNumber: '#2',
        status: OrderStatusApiValues.cancelled,
      ),
    ], false);
    final viewModel = buildViewModel();
    addTearDown(viewModel.close);
    await viewModel.onEvent(const LoadOrderHistory());

    await pumpView(tester, viewModel);

    expect(find.byType(OrdersHistoryCount), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pump();

    expect(find.byType(OrderHistoryCard), findsNWidgets(2));
  });

  testWidgets('shows the load more footer when more pages remain', (
    tester,
  ) async {
    stubFirstPage(const [
      OrderHistoryEntity(id: '1', status: OrderStatusApiValues.delivered),
    ], true);
    final viewModel = buildViewModel();
    addTearDown(viewModel.close);
    await viewModel.onEvent(const LoadOrderHistory());

    await pumpView(tester, viewModel);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pump();

    expect(find.byType(OrderHistoryLoadMoreFooter), findsOneWidget);
    expect(find.byKey(WidgetKeys.orderHistoryLoadMoreButton), findsOneWidget);
  });
}
