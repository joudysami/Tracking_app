import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/home/data/data_source/orders_data_source.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';
import 'package:tracking_app/features/home/domain/repo/order_repo.dart';

@Injectable(as: OrderRepo)
class OrdersRepoImpl implements OrderRepo {
  final OrdersRemoteDataSource remoteDataSource;
  final SafeCall safeCall;

  OrdersRepoImpl(this.remoteDataSource, this.safeCall);
  @override
  Future<
    BaseResponse<
      ({List<AvailableOrderEntity> orders, PaginationEntity pagination})
    >
  >
  getAvailableOrders({required int page, required int pageSize}) async {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getAvailableOrders(
        page: page,
        pageSize: pageSize,
      );

      return (
        orders: response.data.map((order) => order.toDomain()).toList(),
        pagination: response.pagination.toDomain(),
      );
    });
  }

  @override
  Future<BaseResponse<ClaimedOrderEntity>> claimOrder({
    required String orderId,
  }) async {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.claimOrder(orderId: orderId);

      if (!response.status) {
        throw Exception(response.message);
      }

      return response.data!;
    });
  }
}
