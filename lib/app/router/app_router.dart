import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/success_apply_page.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/page/forget_password_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/login_page.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_viewmodel.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/button_navigation_bar.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/features/order/order_screen.dart';
import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';
import 'package:tracking_app/features/profile/profile.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({String? initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation ?? AppRoutes.onBoarding,
      errorBuilder: _errorBuilder,
      routes: [
        _onBordingRoute(),
        _loginRoute(),
        _applyRoute(),
        _successApplyRoute(),
        _forgetPasswordRoute(),
        _homeRoute(),
        _profileRoute(),
        _orderRoute(),
      ],
    );
  }

  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return const Scaffold(body: Center(child: Text(AppConstants.pageNotFound)));
  }

  static GoRoute _loginRoute() {
    return GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<LoginViewModel>(),
          child: const LoginPage(),
        );
      },
    );
  }

  static GoRoute _onBordingRoute() {
    return GoRoute(
      path: AppRoutes.onBoarding,
      builder: (context, state) {
        return const OnBordingPage();
      },
    );
  }

  static GoRoute _applyRoute() {
    return GoRoute(
      path: AppRoutes.apply,
      builder: (context, state) {
        return BlocProvider(
          create: (_) =>
              getIt<ApplyViewModel>()..doEvent(VehicleTypesRequested()),
          child: const ApplyPage(),
        );
      },
    );
  }

  static GoRoute _successApplyRoute() {
    return GoRoute(
      path: AppRoutes.successApply,
      builder: (context, state) {
        return const SuccessApplyPage();
      },
    );
  }

  static GoRoute _forgetPasswordRoute() {
    return GoRoute(
      path: AppRoutes.forgetPassword,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => getIt<ForgetPasswordViewModel>(),
          child: const ForgetPasswordPage(),
        );
      },
    );
  }

  static GoRoute _homeRoute() {
    return GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return BlocProvider(
          create: (_) =>
              getIt<HomeCubit>()..doEvent(const GetAvailableOrdersEvent()),
          child: const ButtonNavigationBar(),
        );
      },
    );
  }

  static GoRoute _profileRoute() {
    return GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {
        return ProfileScreen();
      },
    );
  }

  static GoRoute _orderRoute() {
    return GoRoute(
      path: AppRoutes.order,
      builder: (context, state) {
        return OrderScreen();
      },
    );
  }
}
