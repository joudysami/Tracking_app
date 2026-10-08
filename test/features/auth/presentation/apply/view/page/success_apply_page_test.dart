import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/router/app_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/success_apply_page.dart';
import 'package:tracking_app/features/auth/presentation/login/page/login_page.dart';

void main() {
  Widget buildTestWidget({Widget? home, String? initialLocation}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        if (home != null) {
          return MaterialApp(
            home: home,
          );
        }
        return MaterialApp.router(
          routerConfig: AppRouter.createRouter(
            initialLocation: initialLocation ?? AppRoutes.successApply,
          ),
        );
      },
    );
  }

  testWidgets('Verify SuccessApplyPage structure and localization', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      buildTestWidget(home: const SuccessApplyPage()),
    );
    await tester.pump();

    // Verify Scaffold and AppButton presence
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);

    // Verify texts come from localization (not hardcoded)
    expect(find.text(LocaleKeys.applySuccessTitle.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.applySuccessBody.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.authLogin.tr()), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify navigation to LoginPage when tapping Login', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      buildTestWidget(initialLocation: AppRoutes.successApply),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SuccessApplyPage), findsOneWidget);

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
