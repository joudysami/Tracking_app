import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/router/app_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';
import 'package:tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/view_model/login_view_model.dart';

void main() {
  late Map<String, dynamic> english;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _mockSharedPreferences();
    await EasyLocalization.ensureInitialized();
    english =
        jsonDecode(File('assets/translations/en.json').readAsStringSync())
            as Map<String, dynamic>;
  });

  setUp(() {
    ScreenUtil.configure(
      data: const MediaQueryData(size: Size(375, 812)),
      designSize: const Size(375, 812),
      minTextAdapt: false,
      splitScreenMode: false,
    );
  });

  testWidgets('shows inline validation and a disabled continue button', (
    tester,
  ) async {
    await _pump(tester, LoginViewModel(LoginUseCase(_Repo())), english);

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forget password?'), findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.pump();
    expect(find.text('This Email is not valid'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.pump();
    expect(find.text('Please enter your email'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'x');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.pump();
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('shows a loading button then opens home', (tester) async {
    final repo = _Repo.hanging();
    await _pump(tester, LoginViewModel(LoginUseCase(repo)), english);
    await _fill(tester);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repo.release(const SuccessResponse(AuthSession(role: 'CUSTOMER')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('session-home')), findsOneWidget);
  });

  testWidgets('separates credential errors from the server banner', (
    tester,
  ) async {
    final credential = _Repo(
      ErrorResponse(appError: BadResponseError('Invalid email or password')),
    );
    await _pump(tester, LoginViewModel(LoginUseCase(credential)), english);
    await _fill(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('credential-error')), findsOneWidget);
    expect(find.byKey(const Key('server-error-banner')), findsNothing);

    final server = _Repo(
      ErrorResponse(appError: TimeOutError(Exception('slow'))),
    );
    await _pump(tester, LoginViewModel(LoginUseCase(server)), english);
    await _fill(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('server-error-banner')), findsOneWidget);
    expect(find.byKey(const Key('credential-error')), findsNothing);
  });
}

Future<void> _fill(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'rider@example.com');
  await tester.enterText(find.byType(TextFormField).at(1), 'secret');
  await tester.pump();
}

void _mockSharedPreferences() {
  const channel = MethodChannel('plugins.flutter.io/shared_preferences');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getAll') return <String, Object>{};
        return null;
      });
}

Future<void> _pump(
  WidgetTester tester,
  LoginViewModel model,
  Map<String, dynamic> english,
) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      assetLoader: _MapLoader(english),
      child: Builder(builder: (context) => _app(context, model)),
    ),
  );
  await tester.pumpAndSettle();
}

class _MapLoader extends AssetLoader {
  const _MapLoader(this.data);

  final Map<String, dynamic> data;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async => data;
}

Widget _app(BuildContext context, LoginViewModel model) {
  return MaterialApp.router(
    theme: AppTheme(lightThemeColors).themeData,
    locale: context.locale,
    supportedLocales: context.supportedLocales,
    localizationsDelegates: context.localizationDelegates,
    routerConfig: AppRouter.createRouter(
      initialLocation: AppRoutes.login,
      loginViewModel: model,
    ),
  );
}

class _Repo implements AuthRepo {
  _Repo([this.result]);

  _Repo.hanging() : result = null;

  BaseResponse<AuthSession>? result;
  final Completer<BaseResponse<AuthSession>> _pending = Completer();

  void release(BaseResponse<AuthSession> value) {
    if (!_pending.isCompleted) _pending.complete(value);
  }

  @override
  Future<BaseResponse<AuthSession>> signIn(LoginRequest request) async {
    final value = result;
    if (value != null) return value;
    return _pending.future;
  }

  @override
  Future<AuthSession?> currentSession() async => null;

  @override
  Future<bool> accessTokenExpired() async => false;

  @override
  Future<AuthSession> refreshSession() => throw UnimplementedError();
}
