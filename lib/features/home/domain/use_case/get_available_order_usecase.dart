import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';
import 'package:tracking_app/features/home/domain/repo/order_repo.dart';

@injectable
class GetAvailableOrdersUseCase {
  final OrderRepo orderRepo;

  GetAvailableOrdersUseCase(this.orderRepo);

  Future<
    BaseResponse<
      ({List<AvailableOrderEntity> orders, PaginationEntity pagination})
    >
  >
  call({int page = 1, int pageSize = 20}) {
    return orderRepo.getAvailableOrders(page: page, pageSize: pageSize);
  }
}
