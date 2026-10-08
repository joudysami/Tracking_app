import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/app/router/app_router.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/login/page/login_page.dart';
import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';

class MockApplyViewModel extends Cubit<ApplyState> implements ApplyViewModel {
  MockApplyViewModel() : super(const ApplyState());
  @override
  Future<void> doEvent(ApplyEvent event) async {}
}

void main() {
  setUpAll(() {
    if (!getIt.isRegistered<ApplyViewModel>()) {
      getIt.registerFactory<ApplyViewModel>(() => MockApplyViewModel());
    }
  });

  testWidgets('Verify onboarding screen structure', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      ScreenUtilInit(
        child: const MaterialApp(
          home: OnBordingPage(),
        ),
      ),
    );

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Lottie), findsOneWidget);
    expect(find.byType(AppButton), findsNWidgets(2));

    expect(
      find.text(LocaleKeys.onboardingWelcome.tr()),
      findsOneWidget,
    );

    expect(find.text(LocaleKeys.authLogin.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.commonApply.tr()), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify navigation to login page', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      ScreenUtilInit(
        child: MaterialApp.router(routerConfig: AppRouter.createRouter()),
      ),
    );

    await tester.tap(find.text(LocaleKeys.authLogin.tr()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify navigation to apply page', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      ScreenUtilInit(
        child: MaterialApp.router(routerConfig: AppRouter.createRouter()),
      ),
    );

    await tester.tap(find.text(LocaleKeys.commonApply.tr()));
    await tester.pumpAndSettle();

    expect(find.byType(ApplyPage), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
