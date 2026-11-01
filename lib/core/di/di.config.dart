// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:geolocator/geolocator.dart' as _i699;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/api/auth_api_client.dart' as _i710;
import '../../features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i25;
import '../../features/auth/data/data_sources/auth_remote_data_source_impl.dart'
    as _i182;
import '../../features/auth/data/repos/auth_repo_impl.dart' as _i152;
import '../../features/auth/domain/repos/auth_repo.dart' as _i877;
import '../../features/auth/domain/use_cases/apply_use_case.dart' as _i743;
import '../../features/auth/domain/use_cases/forget_password_use_case.dart'
    as _i483;
import '../../features/auth/domain/use_cases/get_vehicle_types_usecase.dart'
    as _i311;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/logout_use_case.dart' as _i698;
import '../../features/auth/domain/use_cases/reset_password_use_case.dart'
    as _i169;
import '../../features/auth/domain/use_cases/verify_otp_use_case.dart' as _i908;
import '../../features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart'
    as _i678;
import '../../features/auth/presentation/forget_password/view_model/forget_password_view_model.dart'
    as _i346;
import '../../features/auth/presentation/login/view/page/view_model/login_viewmodel.dart'
    as _i725;
import '../../features/home/data/api/home_api_client.dart' as _i549;
import '../../features/home/data/data_source/home_data_source.dart' as _i68;
import '../../features/home/data/data_source/home_data_source_impl.dart'
    as _i291;
import '../../features/home/data/repo/home_repo_impl.dart' as _i1024;
import '../../features/home/domain/repo/home_repo.dart' as _i280;
import '../../features/home/domain/use_case/claim_order_usecase.dart' as _i610;
import '../../features/home/domain/use_case/get_assigned_order_usecase.dart'
    as _i858;
import '../../features/home/domain/use_case/get_available_order_usecase.dart'
    as _i264;
import '../../features/home/presentation/view_model/home_view_model.dart'
    as _i77;
import '../../features/location_tracking/api/location_api_client.dart' as _i692;
import '../../features/location_tracking/api/routing_api_client.dart' as _i821;
import '../../features/location_tracking/data/data_sources/location_remote_data_source.dart'
    as _i405;
import '../../features/location_tracking/data/data_sources/location_remote_data_source_impl.dart'
    as _i981;
import '../../features/location_tracking/data/repos/location_repo_impl.dart'
    as _i1033;
import '../../features/location_tracking/domain/repos/location_repo.dart'
    as _i1053;
import '../../features/location_tracking/domain/use_cases/check_and_request_location_permission_use_case.dart'
    as _i553;
import '../../features/location_tracking/domain/use_cases/get_route_use_case.dart'
    as _i221;
import '../../features/location_tracking/domain/use_cases/is_location_service_enabled_use_case.dart'
    as _i521;
import '../../features/location_tracking/domain/use_cases/location_reporting_use_case.dart'
    as _i541;
import '../../features/location_tracking/domain/use_cases/location_tracking_use_case.dart'
    as _i258;
import '../../features/location_tracking/domain/use_cases/open_app_settings_use_case.dart'
    as _i536;
import '../../features/location_tracking/domain/use_cases/open_location_settings_use_case.dart'
    as _i528;
import '../../features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart'
    as _i783;
import '../../features/order/data/api/order_api_client.dart' as _i1026;
import '../../features/order/data/data_source/order_data_source.dart' as _i173;
import '../../features/order/data/data_source/order_data_source_impl.dart'
    as _i578;
import '../../features/order/data/data_sources/order_remote_data_source.dart'
    as _i701;
import '../../features/order/data/data_sources/order_remote_data_source_impl.dart'
    as _i352;
import '../../features/order/data/repo/order_repo_impl.dart' as _i492;
import '../../features/order/data/repos/order_repo_impl.dart' as _i906;
import '../../features/order/domain/repo/order_repo.dart' as _i989;
import '../../features/order/domain/repos/order_repo.dart' as _i527;
import '../../features/order/domain/use_case/confirm_delivery_usecase.dart'
    as _i690;
import '../../features/order/domain/use_case/order_status_use_case.dart'
    as _i571;
import '../../features/order/domain/use_cases/get_order_count_use_case.dart'
    as _i98;
import '../../features/order/domain/use_cases/get_orders_history_use_case.dart'
    as _i252;
import '../../features/order/presentation/order_history/view_model/order_history_view_model.dart'
    as _i477;
import '../../features/order/presentation/view_model/order_view_model.dart'
    as _i124;
import '../../features/profile/api/profile_api_client.dart' as _i211;
import '../../features/profile/data/data_sources/profile_remote_data_source.dart'
    as _i1012;
import '../../features/profile/data/data_sources/profile_remote_data_source_impl.dart'
    as _i491;
import '../../features/profile/data/repos/profile_repo_impl.dart' as _i1072;
import '../../features/profile/domain/repos/profile_repo.dart' as _i1007;
import '../../features/profile/domain/use_cases/change_password_use_case.dart'
    as _i266;
import '../../features/profile/domain/use_cases/get_profile_use_case.dart'
    as _i110;
import '../../features/profile/domain/use_cases/get_vehicle_info_use_case.dart'
    as _i167;
import '../../features/profile/domain/use_cases/logout_session_use_case.dart'
    as _i712;
import '../../features/profile/domain/use_cases/update_profile_use_case.dart'
    as _i186;
import '../../features/profile/domain/use_cases/update_vehicle_info_use_case.dart'
    as _i974;
import '../../features/profile/presentation/change_password/view_model/change_password_view_model.dart'
    as _i441;
import '../../features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart'
    as _i1023;
import '../../features/profile/presentation/edit_vehicle/view_model/edit_vehicle_view_model.dart'
    as _i360;
import '../../features/profile/presentation/profile/view_model/profile_view_model.dart'
    as _i197;
import '../modules/api_module.dart' as _i99;
import '../modules/dio_module.dart' as _i948;
import '../modules/services_module.dart' as _i120;
import '../network/auth_interceptors.dart' as _i466;
import '../network/safe_call.dart' as _i185;
import '../network/token_refresh.dart' as _i36;
import '../network/token_storage.dart' as _i964;
import '../services/distance_service.dart' as _i666;
import '../services/geolocator_distance_service.dart' as _i1055;
import '../services/image_picker_service.dart' as _i644;
import '../services/location_service.dart' as _i669;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final servicesModule = _$ServicesModule();
    final dioModule = _$DioModule();
    final apiModule = _$ApiModule();
    gh.factory<_i185.SafeCall>(() => _i185.SafeCall());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => servicesModule.provideFlutterSecureStorage(),
    );
    gh.lazySingleton<_i183.ImagePicker>(
      () => servicesModule.provideImagePicker(),
    );
    gh.lazySingleton<_i699.GeolocatorPlatform>(
      () => servicesModule.provideGeolocator(),
    );
    gh.lazySingleton<_i466.AuthSessionNotifier>(
      () => _i466.AuthSessionNotifier(),
    );
    gh.factory<_i666.DistanceService>(() => _i1055.GeolocatorDistanceService());
    gh.lazySingleton<_i36.TokenRefresher>(() => _i36.ApiTokenRefresher());
    gh.lazySingleton<_i644.ImagePickerService>(
      () => _i644.ImagePickerService(gh<_i183.ImagePicker>()),
    );
    gh.factory<_i669.LocationService>(
      () => _i669.LocationService(gh<_i699.GeolocatorPlatform>()),
    );
    gh.lazySingleton<_i964.TokenStorage>(
      () => _i964.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i466.AuthInterceptors>(
      () => _i466.AuthInterceptors(
        gh<_i964.TokenStorage>(),
        gh<_i36.TokenRefresher>(),
        gh<_i466.AuthSessionNotifier>(),
      ),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.provideDio(gh<_i466.AuthInterceptors>()),
    );
    gh.lazySingleton<_i549.HomeApiClient>(
      () => apiModule.provideHomeApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i710.AuthApiClient>(
      () => apiModule.provideAuthApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i1026.OrderApiClient>(
      () => apiModule.provideOrderApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i211.ProfileApiClient>(
      () => apiModule.provideProfileApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i692.LocationApiClient>(
      () => apiModule.provideLocationApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i821.RoutingApiClient>(
      () => apiModule.provideRoutingApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i1012.ProfileRemoteDataSource>(
      () => _i491.ProfileRemoteDataSourceImpl(gh<_i211.ProfileApiClient>()),
    );
    gh.factory<_i701.OrderRemoteDataSource>(
      () => _i352.OrderRemoteDataSourceImpl(gh<_i1026.OrderApiClient>()),
    );
    gh.factory<_i1007.ProfileRepo>(
      () => _i1072.ProfileRepoImpl(
        remote: gh<_i1012.ProfileRemoteDataSource>(),
        safeCall: gh<_i185.SafeCall>(),
        tokenStorage: gh<_i964.TokenStorage>(),
      ),
    );
    gh.factory<_i25.AuthRemoteDataSource>(
      () =>
          _i182.AuthRemoteDataSourceImpl(apiClient: gh<_i710.AuthApiClient>()),
    );
    gh.factory<_i405.LocationRemoteDataSource>(
      () => _i981.LocationRemoteDataSourceImpl(
        apiClient: gh<_i692.LocationApiClient>(),
        routingApiClient: gh<_i821.RoutingApiClient>(),
      ),
    );
    gh.factory<_i173.OrdersRemoteDataSource>(
      () => _i578.OrdersRemoteDataSourceImpl(
        orderApiClient: gh<_i1026.OrderApiClient>(),
      ),
    );
    gh.factory<_i1053.LocationRepo>(
      () => _i1033.LocationRepoImpl(
        gh<_i669.LocationService>(),
        gh<_i185.SafeCall>(),
        remoteDataSource: gh<_i405.LocationRemoteDataSource>(),
      ),
    );
    gh.factory<_i527.OrderRepo>(
      () => _i906.OrderRepoImpl(
        gh<_i701.OrderRemoteDataSource>(),
        gh<_i185.SafeCall>(),
      ),
    );
    gh.factory<_i541.LocationReportingUseCase>(
      () => _i541.LocationReportingUseCase(
        gh<_i1053.LocationRepo>(),
        gh<_i666.DistanceService>(),
      ),
    );
    gh.factory<_i877.AuthRepo>(
      () => _i152.AuthRepoImpl(
        remoteDataSource: gh<_i25.AuthRemoteDataSource>(),
        safeCall: gh<_i185.SafeCall>(),
        tokenStorage: gh<_i964.TokenStorage>(),
      ),
    );
    gh.factory<_i68.HomeRemoteDataSource>(
      () => _i291.HomeRemoteDataSourceImpl(
        homeApiClient: gh<_i549.HomeApiClient>(),
      ),
    );
    gh.factory<_i252.GetOrdersHistoryUseCase>(
      () => _i252.GetOrdersHistoryUseCase(gh<_i527.OrderRepo>()),
    );
    gh.factory<_i266.ChangePasswordUseCase>(
      () => _i266.ChangePasswordUseCase(gh<_i1007.ProfileRepo>()),
    );
    gh.factory<_i110.GetProfileUseCase>(
      () => _i110.GetProfileUseCase(gh<_i1007.ProfileRepo>()),
    );
    gh.factory<_i167.GetVehicleInfoUseCase>(
      () => _i167.GetVehicleInfoUseCase(gh<_i1007.ProfileRepo>()),
    );
    gh.factory<_i712.LogoutSessionUseCase>(
      () => _i712.LogoutSessionUseCase(gh<_i1007.ProfileRepo>()),
    );
    gh.factory<_i186.UpdateProfileUseCase>(
      () => _i186.UpdateProfileUseCase(gh<_i1007.ProfileRepo>()),
    );
    gh.factory<_i974.UpdateVehicleInfoUseCase>(
      () => _i974.UpdateVehicleInfoUseCase(gh<_i1007.ProfileRepo>()),
    );
    gh.factory<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i725.LoginViewModel>(
      () => _i725.LoginViewModel(gh<_i1038.LoginUseCase>()),
    );
    gh.factory<_i989.OrderRepo>(
      () => _i492.OrdersRepoImpl(
        gh<_i173.OrdersRemoteDataSource>(),
        gh<_i185.SafeCall>(),
      ),
    );
    gh.factory<_i441.ChangePasswordViewModel>(
      () => _i441.ChangePasswordViewModel(gh<_i266.ChangePasswordUseCase>()),
    );
    gh.factory<_i553.CheckAndRequestLocationPermissionUseCase>(
      () => _i553.CheckAndRequestLocationPermissionUseCase(
        gh<_i1053.LocationRepo>(),
      ),
    );
    gh.factory<_i221.GetRouteUseCase>(
      () => _i221.GetRouteUseCase(gh<_i1053.LocationRepo>()),
    );
    gh.factory<_i521.IsLocationServiceEnabledUseCase>(
      () => _i521.IsLocationServiceEnabledUseCase(gh<_i1053.LocationRepo>()),
    );
    gh.factory<_i258.LocationTrackingUseCase>(
      () => _i258.LocationTrackingUseCase(gh<_i1053.LocationRepo>()),
    );
    gh.factory<_i536.OpenAppSettingsUseCase>(
      () => _i536.OpenAppSettingsUseCase(gh<_i1053.LocationRepo>()),
    );
    gh.factory<_i528.OpenLocationSettingsUseCase>(
      () => _i528.OpenLocationSettingsUseCase(gh<_i1053.LocationRepo>()),
    );
    gh.factory<_i98.GetOrdersCountUseCase>(
      () => _i98.GetOrdersCountUseCase(gh<_i527.OrderRepo>()),
    );
    gh.factory<_i783.LocationTrackingViewModel>(
      () => _i783.LocationTrackingViewModel(
        gh<_i258.LocationTrackingUseCase>(),
        gh<_i553.CheckAndRequestLocationPermissionUseCase>(),
        gh<_i521.IsLocationServiceEnabledUseCase>(),
        gh<_i536.OpenAppSettingsUseCase>(),
        gh<_i528.OpenLocationSettingsUseCase>(),
        gh<_i221.GetRouteUseCase>(),
      ),
    );
    gh.factory<_i280.HomeRepo>(
      () => _i1024.HomeRepoImpl(
        gh<_i68.HomeRemoteDataSource>(),
        gh<_i185.SafeCall>(),
      ),
    );
    gh.factory<_i477.OrderHistoryViewModel>(
      () => _i477.OrderHistoryViewModel(
        gh<_i252.GetOrdersHistoryUseCase>(),
        gh<_i98.GetOrdersCountUseCase>(),
      ),
    );
    gh.factory<_i743.ApplyUseCase>(
      () => _i743.ApplyUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i311.GetVehicleTypesUseCase>(
      () => _i311.GetVehicleTypesUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i197.ProfileViewModel>(
      () => _i197.ProfileViewModel(
        gh<_i110.GetProfileUseCase>(),
        gh<_i167.GetVehicleInfoUseCase>(),
        gh<_i712.LogoutSessionUseCase>(),
      ),
    );
    gh.factory<_i483.ForgetPasswordUseCase>(
      () => _i483.ForgetPasswordUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i698.LogoutUseCase>(
      () => _i698.LogoutUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i169.ResetPasswordUseCase>(
      () => _i169.ResetPasswordUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i908.VerifyOtpUseCase>(
      () => _i908.VerifyOtpUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i610.ClaimOrderUseCase>(
      () => _i610.ClaimOrderUseCase(gh<_i280.HomeRepo>()),
    );
    gh.factory<_i858.GetAssignedOrderUseCase>(
      () => _i858.GetAssignedOrderUseCase(gh<_i280.HomeRepo>()),
    );
    gh.factory<_i264.GetAvailableOrdersUseCase>(
      () => _i264.GetAvailableOrdersUseCase(gh<_i280.HomeRepo>()),
    );
    gh.factory<_i346.ForgetPasswordViewModel>(
      () => _i346.ForgetPasswordViewModel(
        gh<_i483.ForgetPasswordUseCase>(),
        gh<_i908.VerifyOtpUseCase>(),
        gh<_i169.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i1023.EditProfileViewModel>(
      () => _i1023.EditProfileViewModel(
        gh<_i110.GetProfileUseCase>(),
        gh<_i186.UpdateProfileUseCase>(),
        gh<_i644.ImagePickerService>(),
      ),
    );
    gh.lazySingleton<_i690.ConfirmDeliveryUseCase>(
      () => _i690.ConfirmDeliveryUseCase(gh<_i989.OrderRepo>()),
    );
    gh.lazySingleton<_i571.UpdateOrderStatusUseCase>(
      () => _i571.UpdateOrderStatusUseCase(gh<_i989.OrderRepo>()),
    );
    gh.factory<_i678.ApplyViewModel>(
      () => _i678.ApplyViewModel(
        gh<_i743.ApplyUseCase>(),
        gh<_i311.GetVehicleTypesUseCase>(),
        gh<_i644.ImagePickerService>(),
      ),
    );
    gh.factory<_i124.OrderViewModel>(
      () => _i124.OrderViewModel(
        updateOrderStatusUseCase: gh<_i571.UpdateOrderStatusUseCase>(),
        confirmDeliveryUseCase: gh<_i690.ConfirmDeliveryUseCase>(),
        locationReportingUseCase: gh<_i541.LocationReportingUseCase>(),
        locationTrackingUseCase: gh<_i258.LocationTrackingUseCase>(),
      ),
    );
    gh.factory<_i360.EditVehicleViewModel>(
      () => _i360.EditVehicleViewModel(
        gh<_i167.GetVehicleInfoUseCase>(),
        gh<_i974.UpdateVehicleInfoUseCase>(),
        gh<_i311.GetVehicleTypesUseCase>(),
        gh<_i644.ImagePickerService>(),
      ),
    );
    gh.factory<_i77.HomeCubit>(
      () => _i77.HomeCubit(
        getAvailableOrdersUseCase: gh<_i264.GetAvailableOrdersUseCase>(),
        claimOrderUseCase: gh<_i610.ClaimOrderUseCase>(),
        getAssignedOrderUseCase: gh<_i858.GetAssignedOrderUseCase>(),
      ),
    );
    return this;
  }
}

class _$ServicesModule extends _i120.ServicesModule {}

class _$DioModule extends _i948.DioModule {}

class _$ApiModule extends _i99.ApiModule {}
