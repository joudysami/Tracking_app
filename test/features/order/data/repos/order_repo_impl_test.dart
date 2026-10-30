import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/api_response.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/utils/pagination/paginated_result.dart';
import 'package:tracking_app/features/order/data/api/order_status_api_values.dart';
import 'package:tracking_app/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:tracking_app/features/order/data/models/order_history_response.dart';
import 'package:tracking_app/features/order/data/repos/order_repo_impl.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';

import 'order_repo_impl_test.mocks.dart';

@GenerateMocks([OrderRemoteDataSource])
void main() {
  late MockOrderRemoteDataSource dataSource;
  late OrderRepoImpl repo;

  setUp(() {
    dataSource = MockOrderRemoteDataSource();
    repo = OrderRepoImpl(dataSource, SafeCall());
  });

  ApiResponse<List<OrderHistoryResponse>> apiResponse({
    bool status = true,
    List<OrderHistoryResponse>? data = const [
      OrderHistoryResponse(id: '1', status: OrderStatusApiValues.delivered),
    ],
    Object? pagination,
  }) {
    return ApiResponse(
      status: status,
      code: 200,
      message: 'ok',
      data: data,
      pagination: pagination,
    );
  }

  group('OrderRepoImpl.getOrders', () {
    test('maps items and server pagination on success', () async {
      when(
        dataSource.getOrderHistory(page: 1, pageSize: 10, status: null),
      ).thenAnswer(
        (_) async => apiResponse(
          pagination: const {'page': 1, 'hasNextPage': true, 'totalCount': 3},
        ),
      );

      final result = await repo.getOrders(page: 1, pageSize: 10);

      final success =
          result as SuccessResponse<PaginatedResult<OrderHistoryEntity>>;
      expect(success.data!.items.map((e) => e.id), ['1']);
      expect(success.data!.pagination.page, 1);
      expect(success.data!.pagination.hasNextPage, isTrue);
      expect(success.data!.pagination.totalCount, 3);
    });

    test(
      'falls back to empty pagination when the payload is not a map',
      () async {
        when(
          dataSource.getOrderHistory(page: 1, pageSize: 10, status: null),
        ).thenAnswer((_) async => apiResponse());

        final result = await repo.getOrders(page: 1, pageSize: 10);

        final success =
            result as SuccessResponse<PaginatedResult<OrderHistoryEntity>>;
        expect(success.data!.items.length, 1);
        expect(success.data!.pagination.page, isNull);
        expect(success.data!.pagination.hasNextPage, isNull);
      },
    );

    test('returns an error response when the api signals failure', () async {
      when(
        dataSource.getOrderHistory(page: 1, pageSize: 10, status: null),
      ).thenAnswer((_) async => apiResponse(status: false));

      final result = await repo.getOrders(page: 1, pageSize: 10);

      expect(result, isA<ErrorResponse<PaginatedResult<OrderHistoryEntity>>>());
    });
  });
}
