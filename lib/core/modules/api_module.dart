import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/api/auth_api_client.dart';
import '../../features/profile/api/profile_api_client.dart';

@module
abstract class ApiModule {
  @singleton
  AuthApiClient provideAuthApiClient(Dio dio) => AuthApiClient(dio);

  @singleton
  ProfileApiClient provideProfileApiClient(Dio dio) => ProfileApiClient(dio);
}
