import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';
import 'package:tracking_app/features/home/domain/repo/order_repo.dart';

class GetAvailableOrdersUseCase {
  final OrderRepo orderRepo;

  GetAvailableOrdersUseCase(this.orderRepo);

  Future<({List<AvailableOrderEntity> orders, PaginationEntity pagination})>
  call({int page = 1, int pageSize = 20}) {
    return orderRepo.getAvailableOrders(page: page, pageSize: pageSize);
  }
}
