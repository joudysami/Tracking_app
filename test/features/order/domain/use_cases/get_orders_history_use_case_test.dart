import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/utils/pagination/paginated_result.dart';
import 'package:tracking_app/features/order/data/api/order_status_api_values.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/order/domain/entities/pagination_params.dart';
import 'package:tracking_app/features/order/domain/repos/order_repo.dart';
import 'package:tracking_app/features/order/domain/use_cases/get_orders_history_use_case.dart';

import 'get_orders_history_use_case_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  provideDummy<BaseResponse<PaginatedResult<OrderHistoryEntity>>>(
    const SuccessResponse<PaginatedResult<OrderHistoryEntity>>(
      PaginatedResult(items: [], pagination: PaginationParams()),
    ),
  );

  late MockOrderRepo mockRepo;
  late GetOrdersHistoryUseCase useCase;

  setUp(() {
    mockRepo = MockOrderRepo();
    useCase = GetOrdersHistoryUseCase(mockRepo);
  });

  group('GetOrdersHistoryUseCase', () {
    test('keeps delivered and cancelled orders', () async {
      when(mockRepo.getOrders(page: 1, pageSize: 10)).thenAnswer(
        (_) async => SuccessResponse(
          PaginatedResult(
            items: [
              const OrderHistoryEntity(status: 'PLACED'),
              const OrderHistoryEntity(status: 'PREPARING'),
              const OrderHistoryEntity(status: 'PICKED_UP'),
              const OrderHistoryEntity(status: 'OUT_FOR_DELIVERY'),
              const OrderHistoryEntity(status: 'ARRIVED'),
              const OrderHistoryEntity(
                status: 'AWAITING_DELIVERY_CONFIRMATION',
              ),
              const OrderHistoryEntity(status: OrderStatusApiValues.delivered),
              const OrderHistoryEntity(status: OrderStatusApiValues.cancelled),
            ],
            pagination: const PaginationParams(hasNextPage: true),
          ),
        ),
      );

      final result = await useCase.call(page: 1, pageSize: 10);

      final data =
          (result as SuccessResponse<PaginatedResult<OrderHistoryEntity>>)
              .data!;
      expect(data.items.length, 2);
      expect(
        data.items.map((e) => e.status),
        [
          OrderStatusApiValues.delivered,
          OrderStatusApiValues.cancelled,
        ],
      );
    });

    test('keeps server pagination while filtering history items', () async {
      when(mockRepo.getOrders(page: 2, pageSize: 10)).thenAnswer(
        (_) async => SuccessResponse(
          PaginatedResult(
            items: [
              const OrderHistoryEntity(status: 'PLACED'),
              const OrderHistoryEntity(status: OrderStatusApiValues.cancelled),
            ],
            pagination: const PaginationParams(
              hasNextPage: true,
              totalCount: 42,
            ),
          ),
        ),
      );

      final result = await useCase.call(page: 2, pageSize: 10);

      final data =
          (result as SuccessResponse<PaginatedResult<OrderHistoryEntity>>)
              .data!;
      expect(data.items.map((e) => e.status), [OrderStatusApiValues.cancelled]);
      expect(data.pagination.hasNextPage, isTrue);
      expect(data.pagination.totalCount, 42);
    });

    test(
      'returns empty items but keeps hasMore when page has no history',
      () async {
        when(mockRepo.getOrders(page: 1, pageSize: 10)).thenAnswer(
          (_) async => SuccessResponse(
            PaginatedResult(
              items: [
                const OrderHistoryEntity(status: 'PLACED'),
                const OrderHistoryEntity(status: 'PREPARING'),
                const OrderHistoryEntity(status: 'ARRIVED'),
              ],
              pagination: const PaginationParams(hasNextPage: true),
            ),
          ),
        );

        final result = await useCase.call(page: 1, pageSize: 10);

        final data =
            (result as SuccessResponse<PaginatedResult<OrderHistoryEntity>>)
                .data!;
        expect(data.items, isEmpty);
        expect(data.pagination.hasNextPage, isTrue);
      },
    );

    test('passes through repo error untouched', () async {
      when(mockRepo.getOrders(page: 1, pageSize: 10)).thenAnswer(
        (_) async => ErrorResponse<PaginatedResult<OrderHistoryEntity>>(
          appError: BadResponseError('nope'),
        ),
      );

      final result = await useCase.call(page: 1, pageSize: 10);

      expect(result, isA<ErrorResponse<PaginatedResult<OrderHistoryEntity>>>());
      expect(
        (result as ErrorResponse<PaginatedResult<OrderHistoryEntity>>)
            .appError
            .message,
        'nope',
      );
    });
  });
}
