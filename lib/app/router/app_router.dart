import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/page/forget_password_page.dart';
import 'package:tracking_app/features/auth/presentation/login/page/login_page.dart';
import 'package:tracking_app/features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({
    String? initialLocation,
    LoginViewModel? loginViewModel,
  }) {
    return GoRouter(
      initialLocation: initialLocation ?? AppRoutes.onBoarding,
      errorBuilder: _errorBuilder,
      routes: [
        _onBordingRoute(),
        _loginRoute(loginViewModel),
        _homeRoute(),
        _applyRoute(),
        _forgetPasswordRoute(),
      ],
    );
  }

  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return const Scaffold(body: Center(child: Text(AppConstants.pageNotFound)));
  }

  static GoRoute _onBordingRoute() {
    return GoRoute(
      path: AppRoutes.onBoarding,
      builder: (context, state) => const OnBordingPage(),
    );
  }

  static GoRoute _loginRoute(LoginViewModel? loginViewModel) {
    return GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => LoginPage(viewModel: loginViewModel),
    );
  }

  static GoRoute _homeRoute() {
    return GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const _SessionDestination(),
    );
  }

  static GoRoute _applyRoute() {
    return GoRoute(
      path: AppRoutes.apply,
      builder: (context, state) => const ApplyPage(),
    );
  }

  static GoRoute _forgetPasswordRoute() {
    return GoRoute(
      path: AppRoutes.forgetPassword,
      builder: (context, state) => const ForgetPasswordPage(),
    );
  }
}

class _SessionDestination extends StatelessWidget {
  const _SessionDestination();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(LocaleKeys.navHome.tr(), key: const Key('session-home')),
      ),
    );
  }
}
