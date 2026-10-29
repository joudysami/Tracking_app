import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/home/data/api/home_api_client.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source.dart';
import 'package:tracking_app/features/home/data/models/available_orders_response.dart';
import 'package:tracking_app/features/home/data/models/claim_order_response.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HomeApiClient homeApiClient;
  HomeRemoteDataSourceImpl({required this.homeApiClient});
  @override
  Future<AvailableOrdersResponse> getAvailableOrders({
    required int page,
    required int pageSize,
  }) {
    return homeApiClient.getAvailableOrders(page: page, pageSize: pageSize);
  }

  @override
  Future<ClaimOrderResponse> claimOrder({required String orderId}) {
    return homeApiClient.claimOrder(orderId: orderId);
  }
}
