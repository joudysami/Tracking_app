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
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/api/auth_api_client.dart' as _i541;
import '../../features/auth/data/data_source/auth_remote_data_source.dart'
    as _i182;
import '../../features/auth/data/data_source/auth_remote_data_source_impl.dart'
    as _i508;
import '../../features/auth/data/repo/auth_repo_impl.dart' as _i984;
import '../../features/auth/domain/repo/auth_repo.dart' as _i170;
import '../../features/auth/domain/use_case/login_use_case.dart' as _i973;
import '../../features/auth/domain/use_case/restore_session_use_case.dart'
    as _i909;
import '../../features/auth/presentation/login/view_model/login_view_model.dart'
    as _i671;
import '../modules/dio_module.dart' as _i948;
import '../modules/storage_module.dart' as _i348;
import '../network/auth_interceptors.dart' as _i466;
import '../network/safe_call.dart' as _i185;
import '../network/token_refresh.dart' as _i36;
import '../network/token_storage.dart' as _i964;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    final dioModule = _$DioModule();
    gh.factory<_i185.SafeCall>(() => _i185.SafeCall());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => storageModule.secureStorage,
    );
    gh.lazySingleton<_i466.AuthSessionNotifier>(
      () => _i466.AuthSessionNotifier(),
    );
    gh.lazySingleton<_i36.TokenRefresher>(() => _i36.ApiTokenRefresher());
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
    gh.lazySingleton<_i541.AuthApiClient>(
      () => _i541.AuthApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i182.AuthRemoteDataSource>(
      () => _i508.AuthRemoteDataSourceImpl(gh<_i541.AuthApiClient>()),
    );
    gh.factory<_i170.AuthRepo>(
      () => _i984.AuthRepositoryImpl(
        gh<_i182.AuthRemoteDataSource>(),
        gh<_i185.SafeCall>(),
        gh<_i964.TokenStorage>(),
        gh<_i36.TokenRefresher>(),
      ),
    );
    gh.factory<_i973.LoginUseCase>(
      () => _i973.LoginUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i671.LoginViewModel>(
      () => _i671.LoginViewModel(gh<_i973.LoginUseCase>()),
    );
    gh.factory<_i909.RestoreSessionUseCase>(
      () => _i909.RestoreSessionUseCase(gh<_i170.AuthRepo>()),
    );
    return this;
  }
}

class _$StorageModule extends _i348.StorageModule {}

class _$DioModule extends _i948.DioModule {}
