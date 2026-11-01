import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/order/domain/enitiy/confirm_delivery_entity.dart';
import 'package:tracking_app/features/order/domain/repo/order_repo.dart';

@lazySingleton
class ConfirmDeliveryUseCase {
  final OrderRepo repo;

  ConfirmDeliveryUseCase(this.repo);

  Future<BaseResponse<ConfirmDeliveryEntity>> call({required String orderId}) {
    return repo.confirmDelivery(orderId: orderId);
  }
}
