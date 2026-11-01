import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/api_exception.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/order/data/data_source/order_data_source.dart';
import 'package:tracking_app/features/order/domain/enitiy/confirm_delivery_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';
import 'package:tracking_app/features/order/domain/repo/order_repo.dart';

@Injectable(as: OrderRepo)
class OrdersRepoImpl implements OrderRepo {
  final OrdersRemoteDataSource remoteDataSource;
  final SafeCall safeCall;

  OrdersRepoImpl(this.remoteDataSource, this.safeCall);

  @override
  Future<BaseResponse<ConfirmDeliveryEntity>> confirmDelivery({
    required String orderId,
  }) async {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.confirmDelivery(orderId: orderId);

      if (!response.status) {
        throw ApiException(message: response.message);
      }

      final data = response.data;
      if (data == null) {
        throw ApiException(message: 'Delivery confirmation data is empty.');
      }

      return data.toDomain();
    });
  }

  @override
  Future<BaseResponse<OrderDetailsEntity>> updateStatus({
    required String orderId,
    required String status,
    required String note,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.updateStatus(
        orderId: orderId,
        status: status,
        note: note,
      );

      if (response.status == false) {
        throw ApiException(
          message: response.message ?? 'Could not update the order status.',
          statusCode: response.code,
        );
      }

      // The status change may be acknowledged with a message only, so the
      // status just sent is used when the payload is missing.
      final data = response.data;

      return OrderDetailsEntity(
        orderId: data?.orderId ?? orderId,
        orderNumber: data?.orderId ?? orderId,
        status: data?.status ?? status,
        createdAt: data?.occurredAt ?? DateTime.now().toIso8601String(),
        customerName: '',
        customerAddress: '',
        storeName: '',
        storeAddress: '',
        totalAmount: 0,
        paymentMethod: 'Cash on delivery',
        items: const [],
      );
    });
  }
}
