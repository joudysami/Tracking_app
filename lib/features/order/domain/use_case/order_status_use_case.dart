
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';
import 'package:tracking_app/features/order/domain/repo/order_repo.dart';


@lazySingleton
class UpdateOrderStatusUseCase {
  final OrderRepo repo;

  UpdateOrderStatusUseCase(this.repo);

  Future<BaseResponse<OrderDetailsEntity>> call({
    required String orderId,
    required String status,
    required String note,
  }) {
    return repo.updateStatus(
      orderId: orderId,
      status: status,
      note: note,
    );
  }
}

