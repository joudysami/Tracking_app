import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/order/domain/enitiy/confirm_delivery_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';

abstract interface class OrderRepo {
  Future<BaseResponse<OrderDetailsEntity>> updateStatus({
    required String orderId,
    required String status,
    required String note,
  });

  Future<BaseResponse<ConfirmDeliveryEntity>> confirmDelivery({
    required String orderId,
  });
}
