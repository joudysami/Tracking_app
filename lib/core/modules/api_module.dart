import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/api/auth_api_client.dart';
import '../../features/location_tracking/api/location_api_client.dart';
import '../../features/location_tracking/api/routing_api_client.dart';

@module
abstract class ApiModule {
  @singleton
  AuthApiClient provideAuthApiClient(Dio dio) => AuthApiClient(dio);

  @singleton
  LocationApiClient provideLocationApiClient(Dio dio) => LocationApiClient(dio);

  @singleton
  RoutingApiClient provideRoutingApiClient(Dio dio) => RoutingApiClient(dio);
}