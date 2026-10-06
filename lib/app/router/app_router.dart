import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/login/page/login_page.dart';
import '../../features/auth/presentation/forget_password/view/page/forget_password_page.dart';

import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';

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
        _forgetPasswordRoute(),
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
        return const LoginPage();
        ;
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
        return const ApplyPage();
       
      },
    );
  }

  static GoRoute _forgetPasswordRoute() {
    return GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return ForgetPasswordPage();
      },
    );
  }
}
