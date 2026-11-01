import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/api_response.dart';
import 'package:tracking_app/features/order/data/api/order_api_client.dart';
import 'package:tracking_app/features/order/data/api/order_status_api_values.dart';
import 'package:tracking_app/features/order/data/data_sources/order_remote_data_source_impl.dart';
import 'package:tracking_app/features/order/data/models/order_history_response.dart';

import 'order_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OrderApiClient])
void main() {
  late MockOrderApiClient apiClient;
  late OrderRemoteDataSourceImpl dataSource;

  final response = ApiResponse<List<OrderHistoryResponse>>(
    status: true,
    code: 200,
    message: 'ok',
    data: const [OrderHistoryResponse(id: '1')],
  );

  setUp(() {
    apiClient = MockOrderApiClient();
    dataSource = OrderRemoteDataSourceImpl(apiClient);
  });

  group('OrderRemoteDataSourceImpl.getOrderHistory', () {
    test('stringifies page params and returns the api response', () async {
      when(
        apiClient.getOrders(
          page: '2',
          pageSize: '10',
          status: OrderStatusApiValues.delivered,
        ),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getOrderHistory(
        page: 2,
        pageSize: 10,
        status: OrderStatusApiValues.delivered,
      );

      expect(result, same(response));
      verify(
        apiClient.getOrders(
          page: '2',
          pageSize: '10',
          status: OrderStatusApiValues.delivered,
        ),
      ).called(1);
    });

    test('passes a null status through untouched', () async {
      when(
        apiClient.getOrders(page: '1', pageSize: '10', status: null),
      ).thenAnswer((_) async => response);

      await dataSource.getOrderHistory(page: 1, pageSize: 10);

      verify(
        apiClient.getOrders(page: '1', pageSize: '10', status: null),
      ).called(1);
    });
  });
}
