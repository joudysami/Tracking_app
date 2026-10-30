import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order/data/api/order_api_client.dart';
import 'package:tracking_app/features/order/data/api/order_status_api_values.dart';
import 'package:tracking_app/features/order/data/models/order_history_response.dart';

import '../../../../support/recording_dio.dart';

void main() {
  const baseUrl = 'https://example.com';
  late List<RecordedRequest> calls;
  late OrderApiClient client;

  setUp(() {
    calls = <RecordedRequest>[];
  });

  group('OrderApiClient.getOrders', () {
    test('hits the history endpoint and parses the envelope', () async {
      final dio = recordingDio(
        baseUrl: baseUrl,
        calls: calls,
        body: <String, dynamic>{
          'status': true,
          'code': 200,
          'message': 'ok',
          'data': <Map<String, dynamic>>[
            {
              'id': '1',
              'orderNumber': '#100',
              'status': OrderStatusApiValues.delivered,
            },
          ],
          'pagination': <String, dynamic>{
            'page': 1,
            'hasNextPage': false,
            'totalCount': 1,
          },
        },
      );
      client = OrderApiClient(dio, baseUrl: baseUrl);

      final response = await client.getOrders(
        page: '1',
        pageSize: '10',
        status: OrderStatusApiValues.delivered,
      );

      expect(calls.single.method, 'GET');
      expect(calls.single.uri.path, '/api/orders/drivers/me/orders');
      expect(calls.single.query['page'], '1');
      expect(calls.single.query['pageSize'], '10');
      expect(calls.single.query['status'], OrderStatusApiValues.delivered);

      expect(response.status, isTrue);
      final data = response.data!;
      expect(data.single, isA<OrderHistoryResponse>());
      expect(data.single.id, '1');
      expect(data.single.status, OrderStatusApiValues.delivered);
      expect(response.pagination, isA<Map>());
    });

    test('omits the status query when it is null', () async {
      final dio = recordingDio(
        baseUrl: baseUrl,
        calls: calls,
        body: <String, dynamic>{
          'status': true,
          'code': 200,
          'message': 'ok',
          'data': <Map<String, dynamic>>[],
        },
      );
      client = OrderApiClient(dio, baseUrl: baseUrl);

      await client.getOrders(page: '2', pageSize: '10');

      expect(calls.single.query.containsKey('status'), isFalse);
    });
  });
}
