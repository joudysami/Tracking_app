import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/features/auth/domain/use_case/restore_session_use_case.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ApiEndpoints.loadBaseUrl();
  await configureDependencies();
  final initialLocation = await getIt<RestoreSessionUseCase>()();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MyApp(initialLocation: initialLocation),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialLocation = AppRoutes.login});

  final String initialLocation;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = AppRouter.createRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => _routerApp(context),
    );
  }

  Widget _routerApp(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: AppTheme(lightThemeColors).themeData,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
