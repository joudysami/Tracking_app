import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/login_page.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_viewmodel.dart';

void main() {
  testWidgets('successful login opens home and sends an empty fcmToken', (
    tester,
  ) async {
    final repo = _LoginRepo();
    final viewModel = LoginViewModel(LoginUseCase(repo));

    final router = GoRouter(
      initialLocation: AppRoutes.login,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) {
            return BlocProvider.value(
              value: viewModel,
              child: const LoginPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Text('home-landed'),
        ),
      ],
    );
    addTearDown(router.dispose);

    ScreenUtil.configure(
      data: const MediaQueryData(size: Size(375, 812)),
      designSize: const Size(375, 812),
      minTextAdapt: false,
      splitScreenMode: false,
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'driver@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Password1');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump();

    expect(find.text('home-landed').evaluate().length, 1);
    expect(repo.request?.email, 'driver@example.com');
    expect(repo.request?.password, 'Password1');
    expect(repo.request?.fcmToken, isEmpty);
  });

  testWidgets('failed login does not open home', (tester) async {
    final repo = _LoginRepo()..fail = true;
    final viewModel = LoginViewModel(LoginUseCase(repo));

    final router = GoRouter(
      initialLocation: AppRoutes.login,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) {
            return BlocProvider.value(
              value: viewModel,
              child: const LoginPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Text('home-landed'),
        ),
      ],
    );
    addTearDown(router.dispose);

    ScreenUtil.configure(
      data: const MediaQueryData(size: Size(375, 812)),
      designSize: const Size(375, 812),
      minTextAdapt: false,
      splitScreenMode: false,
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'driver@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Password1');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump();

    expect(find.text('home-landed').evaluate().length, 0);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(repo.request, isNotNull);
  });
}

class _LoginRepo implements AuthRepo {
  LoginRequest? request;
  bool fail = false;

  @override
  Future<BaseResponse<LoginEntity>> signIn(LoginRequest request) async {
    this.request = request;
    if (fail) {
      return ErrorResponse(appError: BadResponseError('Invalid credentials'));
    }
    return const SuccessResponse(
      LoginEntity(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        role: 'DRIVER',
      ),
    );
  }

  @override
  Future<void> signOut() => throw UnimplementedError();

  @override
  Future<BaseResponse<ApplyResultEntity>> apply(ApplyParams entity) =>
      throw UnimplementedError();

  @override
  Future<BaseResponse<void>> forgetPassword({
    required ForgetPasswordRequest forgetPasswordRequest,
  }) => throw UnimplementedError();

  @override
  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes() =>
      throw UnimplementedError();

  @override
  Future<BaseResponse<void>> resetPassword({
    required ResetPasswordRequest resetPasswordRequest,
  }) => throw UnimplementedError();

  @override
  Future<BaseResponse<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) => throw UnimplementedError();
}
