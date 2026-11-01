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
import 'package:tracking_app/features/order/domain/use_cases/get_order_count_use_case.dart';

import 'get_order_count_use_case_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  provideDummy<BaseResponse<PaginatedResult<OrderHistoryEntity>>>(
    const SuccessResponse<PaginatedResult<OrderHistoryEntity>>(
      PaginatedResult(items: [], pagination: PaginationParams()),
    ),
  );

  late MockOrderRepo mockRepo;
  late GetOrdersCountUseCase useCase;

  setUp(() {
    mockRepo = MockOrderRepo();
    useCase = GetOrdersCountUseCase(mockRepo);
  });

  group('GetOrdersCountUseCase', () {
    test('returns totalCount from pagination when repo succeeds', () async {
      when(
        mockRepo.getOrders(
          page: 1,
          pageSize: 1,
          status: OrderStatusApiValues.delivered,
        ),
      ).thenAnswer(
        (_) async => SuccessResponse<PaginatedResult<OrderHistoryEntity>>(
          PaginatedResult<OrderHistoryEntity>(
            items: const [],
            pagination: const PaginationParams(totalCount: 7),
          ),
        ),
      );

      final result = await useCase.call(status: OrderStatusApiValues.delivered);

      expect(result, isA<SuccessResponse<int?>>());
      expect((result as SuccessResponse<int?>).data, 7);
      verify(
        mockRepo.getOrders(
          page: 1,
          pageSize: 1,
          status: OrderStatusApiValues.delivered,
        ),
      ).called(1);
    });

    test('propagates the error when repo fails', () async {
      when(
        mockRepo.getOrders(
          page: 1,
          pageSize: 1,
          status: OrderStatusApiValues.cancelled,
        ),
      ).thenAnswer(
        (_) async => ErrorResponse<PaginatedResult<OrderHistoryEntity>>(
          appError: BadResponseError('boom'),
        ),
      );

      final result = await useCase.call(status: OrderStatusApiValues.cancelled);

      expect(result, isA<ErrorResponse<int?>>());
      expect((result as ErrorResponse<int?>).appError.message, 'boom');
    });

    test('returns null count when response data is null', () async {
      when(
        mockRepo.getOrders(page: 1, pageSize: 1, status: anyNamed('status')),
      ).thenAnswer(
        (_) async =>
            const SuccessResponse<PaginatedResult<OrderHistoryEntity>>(null),
      );

      final result = await useCase.call(status: OrderStatusApiValues.delivered);

      expect(result, isA<SuccessResponse<int?>>());
      expect((result as SuccessResponse<int?>).data, isNull);
    });
  });
}
