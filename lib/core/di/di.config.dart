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
import '../../features/home/data/api/order_api_client.dart' as _i670;
import '../../features/home/data/data_source/orders_data_source.dart' as _i717;
import '../../features/home/data/data_source/orders_data_source_impl.dart'
    as _i888;
import '../modules/api_module.dart' as _i98;
import '../modules/dio_module.dart' as _i948;
import '../modules/services_module.dart' as _i120;
import '../network/auth_interceptors.dart' as _i466;
import '../network/safe_call.dart' as _i185;
import '../network/token_refresh.dart' as _i36;
import '../network/token_storage.dart' as _i964;
import '../services/image_picker_service.dart' as _i644;

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
    gh.lazySingleton<_i466.AuthSessionNotifier>(
      () => _i466.AuthSessionNotifier(),
    );
    gh.lazySingleton<_i36.TokenRefresher>(() => _i36.ApiTokenRefresher());
    gh.lazySingleton<_i644.ImagePickerService>(
      () => _i644.ImagePickerService(gh<_i183.ImagePicker>()),
    );
    gh.factory<_i717.OrdersRemoteDataSource>(
      () => _i888.OrdersRemoteDataSourceImpl(
        orderApiClient: gh<_i670.OrderApiClient>(),
      ),
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
    gh.singleton<_i710.AuthApiClient>(
      () => apiModule.provideAuthApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i25.AuthRemoteDataSource>(
      () =>
          _i182.AuthRemoteDataSourceImpl(apiClient: gh<_i710.AuthApiClient>()),
    );
    gh.factory<_i877.AuthRepo>(
      () => _i152.AuthRepoImpl(
        remoteDataSource: gh<_i25.AuthRemoteDataSource>(),
        safeCall: gh<_i185.SafeCall>(),
        tokenStorage: gh<_i964.TokenStorage>(),
      ),
    );
    gh.factory<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i725.LoginViewModel>(
      () => _i725.LoginViewModel(gh<_i1038.LoginUseCase>()),
    );
    gh.factory<_i743.ApplyUseCase>(
      () => _i743.ApplyUseCase(gh<_i877.AuthRepo>()),
    );
    gh.factory<_i311.GetVehicleTypesUseCase>(
      () => _i311.GetVehicleTypesUseCase(gh<_i877.AuthRepo>()),
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
    gh.factory<_i346.ForgetPasswordViewModel>(
      () => _i346.ForgetPasswordViewModel(
        gh<_i483.ForgetPasswordUseCase>(),
        gh<_i908.VerifyOtpUseCase>(),
        gh<_i169.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i678.ApplyViewModel>(
      () => _i678.ApplyViewModel(
        gh<_i743.ApplyUseCase>(),
        gh<_i311.GetVehicleTypesUseCase>(),
        gh<_i644.ImagePickerService>(),
      ),
    );
    return this;
  }
}

class _$ServicesModule extends _i120.ServicesModule {}

class _$DioModule extends _i948.DioModule {}

class _$ApiModule extends _i98.ApiModule {}
