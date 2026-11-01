import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/api_exception.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource remoteDataSource;
  final SafeCall safeCall;

  HomeRepoImpl(this.remoteDataSource, this.safeCall);
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
        orders: (response.data ?? const [])
            .map((order) => order.toDomain())
            .toList(),
        pagination:
            response.pagination?.toDomain() ??
            PaginationEntity(
              page: page,
              pageSize: pageSize,
              totalCount: 0,
              totalPages: 0,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
      );
    });
  }

  @override
  Future<BaseResponse<ClaimedOrderEntity>> claimOrder({
    required String orderId,
  }) async {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.claimOrder(orderId: orderId);

      if (response.status == false) {
        throw ApiException(
          message: response.message ?? 'Could not accept this order.',
        );
      }

      final data = response.data;
      if (data == null) {
        throw ApiException(
          message: response.message ?? 'Claimed order data is empty.',
        );
      }

      return data.toDomain();
    });
  }

  @override
  Future<BaseResponse<ClaimedOrderEntity?>> getAssignedOrder() {
    return safeCall.safeApiCall<ClaimedOrderEntity?>(() async {
      final response = await remoteDataSource.getAssignedOrder();

      if (response.status == false) {
        throw ApiException(
          message: response.message ?? 'Could not load your assigned order.',
        );
      }

      // `data: null` simply means the driver is holding no order.
      return response.data?.toDomain();
    });
  }
}
