import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/network/auth_interceptors.dart';
import 'package:tracking_app/core/network/token_refresh.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/home/data/api/home_api_client.dart';

import '../../../support/recording_dio.dart';

void main() {
  const baseUrl = 'https://gateway.test/';

  test('loads available orders with the documented query', () async {
    final calls = <RecordedRequest>[];
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: calls,
      body: _availableOrdersBody(),
    );
    _attachBearer(dio, 'access-token');

    final response = await HomeApiClient(
      dio,
    ).getAvailableOrders(page: 1, pageSize: 20);

    final request = calls.single;
    expect(request.method, 'GET');
    expect(
      request.uri.toString(),
      'https://gateway.test/api/orders/drivers/available-orders?page=1&pageSize=20',
    );
    expect(request.query['page'], 1);
    expect(request.query['pageSize'], 20);
    expect(request.data, isNull);
    expect(request.header('Authorization'), 'Bearer access-token');
    expect(response.status, isTrue);
    expect(response.code, 200);
    expect(response.data.single.orderId, 'order-1');
    expect(response.data.single.status, 'Placed');
    expect(response.data.single.storeName, isEmpty);
    expect(response.data.single.totalAmount, 70);
    expect(response.pagination.pageSize, 20);
    expect(response.pagination.hasNextPage, isFalse);
  });

  test(
    'claims an order by inserting the order id and sending no body',
    () async {
      final calls = <RecordedRequest>[];
      final dio = recordingDio(
        baseUrl: baseUrl,
        calls: calls,
        body: _claimBody(),
      );
      _attachBearer(dio, 'access-token');

      final response = await HomeApiClient(dio).claimOrder(orderId: 'order-1');

      final request = calls.single;
      expect(request.method, 'POST');
      expect(
        request.uri.toString(),
        'https://gateway.test/api/orders/order-1/claim',
      );
      expect(request.data, isNull);
      expect(request.header('Authorization'), 'Bearer access-token');
      expect(response.status, isTrue);
      expect(response.data?.orderId, 'order-1');
      expect(response.data?.status, 'PLACED');
      expect(response.data?.assignmentStatus, 'Accepted');
    },
  );

  test('surfaces a non-2xx available-orders response', () async {
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: [],
      statusCode: 404,
      body: {'status': false, 'code': 404, 'message': 'Not found'},
    );

    expect(
      () => HomeApiClient(dio).getAvailableOrders(page: 1, pageSize: 20),
      throwsA(
        isA<DioException>().having(
          (error) => error.response?.statusCode,
          'statusCode',
          404,
        ),
      ),
    );
  });

  test('rejects an available-orders payload that drops pagination', () async {
    final dio = recordingDio(
      baseUrl: baseUrl,
      calls: [],
      body: {
        'status': true,
        'code': 200,
        'message': 'Available orders retrieved',
        'data': [],
        'pagination': null,
        'errors': null,
      },
    );

    expect(
      () => HomeApiClient(dio).getAvailableOrders(page: 1, pageSize: 20),
      throwsA(isA<TypeError>()),
    );
  });
}

void _attachBearer(Dio dio, String accessToken) {
  final interceptors = AuthInterceptors(
    _FixedTokenStorage(accessToken),
    _UnusedRefresher(),
    AuthSessionNotifier(),
  );
  dio.interceptors.insert(0, interceptors);
  interceptors.attachDio(dio);
}

class _FixedTokenStorage implements TokenStorage {
  _FixedTokenStorage(this.accessToken);

  final String accessToken;

  @override
  Future<void> clearTokens() async {}

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> saveAccessToken(String accessToken) async {}

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}
}

class _UnusedRefresher implements TokenRefresher {
  @override
  Future<AuthTokens?> refresh(String refreshToken) async => null;
}

Map<String, dynamic> _availableOrdersBody() {
  return {
    'status': true,
    'code': 200,
    'message': 'Available orders retrieved',
    'data': [
      {
        'orderId': 'order-1',
        'customerName': 'Customer',
        'customerAddress': 'Customer street',
        'storeId': 'store-1',
        'storeName': '',
        'storeAddress': '',
        'totalAmount': 70,
        'status': 'Placed',
        'createdAt': '2026-08-24T07:46:35.4046149Z',
      },
    ],
    'pagination': {
      'page': 1,
      'pageSize': 20,
      'totalCount': 1,
      'totalPages': 1,
      'hasNextPage': false,
      'hasPreviousPage': false,
    },
    'errors': null,
  };
}

Map<String, dynamic> _claimBody() {
  return {
    'status': true,
    'code': 200,
    'message': 'Order claimed',
    'data': {
      'orderId': 'order-1',
      'orderNumber': 'ORD-EXAMPLE',
      'status': 'PLACED',
      'assignmentStatus': 'Accepted',
      'assignedAt': '2026-09-12T23:08:35.2470789Z',
    },
    'pagination': null,
    'errors': null,
  };
}
