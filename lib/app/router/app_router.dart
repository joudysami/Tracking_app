import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/network/auth_interceptors.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/success_apply_page.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/page/forget_password_page.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/login_page.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_viewmodel.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/button_navigation_bar.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/map_party_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_event.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/page/order_map_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';
import '../../features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import '../../features/auth/presentation/login/view/page/login_page.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_viewmodel.dart';
import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';
import 'package:tracking_app/features/order/order_screen.dart';
import 'package:tracking_app/features/order/presentation/order_details/view/screen/order_details_screen.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_event.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_view_model.dart';

import '../../features/order/presentation/order_details_history/view/screen/order_details_history_screen.dart';
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
      refreshListenable: _sessionChanges(),
      redirect: (context, state) => _sessionAwareRedirect(state),
      routes: [
        _onBordingRoute(),
        _loginRoute(),
        _applyRoute(),
        _successApplyRoute(),
        _forgetPasswordRoute(),
        _homeRoute(),
        _orderRoute(),
        _orderDetailsRoute(),
        _orderSuccessRoute(),
        _profileRoute(),
        _editProfileRoute(),
        _editVehicleRoute(),
        _changePasswordRoute(),
        _orderDetailsHistoryRoute(),
      ],
    );
  }

  static const List<String> _signInRoutes = [
    AppRoutes.onBoarding,
    AppRoutes.login,
    AppRoutes.apply,
    AppRoutes.successApply,
    AppRoutes.forgetPassword,
  ];

  static Listenable? _sessionChanges() {
    try {
      return getIt<AuthSessionNotifier>();
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _sessionAwareRedirect(GoRouterState state) async {
    final isSignInRoute = _signInRoutes.contains(state.matchedLocation);

    final String? accessToken;
    try {
      accessToken = await getIt<TokenStorage>().getAccessToken();
    } catch (_) {
      return null;
    }

    final hasSession = accessToken != null && accessToken.isNotEmpty;

    if (hasSession && isSignInRoute) return AppRoutes.home;
    if (!hasSession && !isSignInRoute) return AppRoutes.login;
    return null;
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

  static GoRoute _homeRoute() {
    return GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<HomeCubit>()
                ..doEvent(const GetAvailableOrdersEvent())
                ..doEvent(const GetAssignedOrderEvent()),
            ),
            BlocProvider(
              create: (_) =>
                  getIt<LocationTrackingViewModel>()
                    ..doEvent(LocationTrackingStarted()),
            ),
          ],
          child: const ButtonNavigationBar(),
        );
      },
    );
  }

  static GoRoute _orderRoute() {
    return GoRoute(
      path: AppRoutes.order,
      builder: (context, state) {
        return OrderScreen(order: state.extra);
      },
    );
  }

  static GoRoute _orderDetailsRoute() {
    return GoRoute(
      path: AppRoutes.orderDetails,
      builder: (context, state) {
        return BlocProvider(
          create: (_) =>
              getIt<OrderViewModel>()
                ..doEvent(InitializeOrderEvent(state.extra)),
          child: OrderDetailsScreen(order: state.extra),
        );
      },
    );
  }

  static GoRoute _orderSuccessRoute() {
    return GoRoute(
      path: AppRoutes.orderSuccess,
      builder: (context, state) {
        return SuccessApplyPage(
          titleKey: LocaleKeys.orderDetailsSuccessTitle,
          bodyKey: LocaleKeys.orderDetailsSuccessBody,
          buttonKey: LocaleKeys.commonDone,
          onButtonPressed: () => context.pop(),
        );
      },
    );
  }

  static GoRoute _orderMapRoute() {
    return GoRoute(
      path: AppRoutes.orderMap,
      builder: (context, state) {
        final extra = state.extra;
        final request = extra is OrderMapRequest ? extra : null;
        final stage =
            request?.stage ??
            (extra is OrderMapStage ? extra : OrderMapStage.pickup);

        return BlocProvider(
          create: (_) =>
              getIt<LocationTrackingViewModel>()
                ..doEvent(LocationTrackingStarted()),
          child: OrderMapPage(order: orderMapFor(request?.order), stage: stage),
        );
      },
    );
  }

  static GoRoute _orderDetailsHistoryRoute() {
    return GoRoute(
      path: AppRoutes.orderDetailsHistory,
      builder: (context, state) => OrderDetailsHistoryScreen(
        orderId: state.extra is String ? state.extra as String : null,
      ),
    );
  }
}
