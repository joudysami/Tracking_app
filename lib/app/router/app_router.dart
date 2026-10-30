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
import '../../features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import '../../features/auth/presentation/login/view/page/login_page.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_viewmodel.dart';
import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view/page/change_password_page.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view/page/edit_profile_page.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view/page/edit_vehicle_page.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile/view/page/profile_page.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_event.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_view_model.dart';

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
        _profileRoute(),
        _editProfileRoute(),
        _editVehicleRoute(),
        _changePasswordRoute(),
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

  static GoRoute _profileRoute() {
    return GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => _profilePage(),
    );
  }

  static Widget _profilePage() {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileViewModel>()..doEvent(const ProfileRequested()),
      child: const ProfilePage(),
    );
  }

  static GoRoute _editProfileRoute() {
    return GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => _editProfilePage(),
    );
  }

  static Widget _editProfilePage() {
    return BlocProvider(
      create: (_) =>
          getIt<EditProfileViewModel>()..doEvent(const EditProfileStarted()),
      child: const EditProfilePage(),
    );
  }

  static GoRoute _editVehicleRoute() {
    return GoRoute(
      path: AppRoutes.editVehicle,
      builder: (context, state) => _editVehiclePage(),
    );
  }

  static Widget _editVehiclePage() {
    return BlocProvider(
      create: (_) =>
          getIt<EditVehicleViewModel>()..doEvent(const EditVehicleStarted()),
      child: const EditVehiclePage(),
    );
  }

  static GoRoute _changePasswordRoute() {
    return GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => _changePasswordPage(),
    );
  }

  static Widget _changePasswordPage() {
    return BlocProvider(
      create: (_) => getIt<ChangePasswordViewModel>(),
      child: const ChangePasswordPage(),
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
}
