import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/api/auth_api_client.dart';
import '../../features/home/data/api/order_api_client.dart';

@module
abstract class ApiModule {
  @singleton
  AuthApiClient provideAuthApiClient(Dio dio) => AuthApiClient(dio);

  @singleton
  OrderApiClient provideOrderApiClient(Dio dio) => OrderApiClient(dio);
}
