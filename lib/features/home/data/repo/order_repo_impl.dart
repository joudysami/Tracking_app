import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/home/data/data_source/orders_data_source.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';
import 'package:tracking_app/features/home/domain/repo/order_repo.dart';

@Injectable(as: OrderRepo)
class OrdersRepoImpl implements OrderRepo {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepoImpl(this.remoteDataSource);

  @override
  Future<({List<AvailableOrderEntity> orders, PaginationEntity pagination})>
  getAvailableOrders({required int page, required int pageSize}) async {
    final response = await remoteDataSource.getAvailableOrders(
      page: page,
      pageSize: pageSize,
    );

    if (!response.status) {
      throw Exception(response.message);
    }

    return (orders: response.data, pagination: response.pagination);
  }

  @override
  Future<ClaimedOrderEntity> claimOrder({required String orderId}) async {
    final response = await remoteDataSource.claimOrder(orderId: orderId);

    if (!response.status || response.data == null) {
      throw Exception(response.message);
    }

    return response.data!;
  }
}
