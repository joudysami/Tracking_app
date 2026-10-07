import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/apply_page.dart';
import '../../features/auth/presentation/forget_password/view/page/forget_password_page.dart';
import '../../features/auth/presentation/login/view/page/login_page.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({String? initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation ?? AppRoutes.forgetPassword,
      errorBuilder: _errorBuilder,
      routes: [
        _loginRoute(),
        _applyRoute(),
        _forgetPasswordRoute(),
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
        return LoginPage();
      },
    );
  }

  static GoRoute _applyRoute() {
    return GoRoute(
      path: AppRoutes.apply,
      builder: (context, state) {
        return ApplyPage();
      },
    );
  }

  static GoRoute _forgetPasswordRoute() {
    return GoRoute(
      path: AppRoutes.forgetPassword,
      builder: (context, state) {
        return ForgetPasswordPage();
      },
    );
  }
}
