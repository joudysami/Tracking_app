import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/app/router/app_router.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/features/auth/presentation/apply/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/login/page/login_page.dart';
import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';

void main() {
  testWidgets('Verify onboarding screen structure', (
    WidgetTester tester,
  ) async {
    // AAA

    // Arrange

    // Act
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      ScreenUtilInit(
        child: const MaterialApp(
          home: OnBordingPage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Lottie), findsOneWidget);
    expect(find.byType(AppButton), findsNWidgets(2));

    expect(
      find.text(AppConstants.welcometoFloweryRiderApp),
      findsOneWidget,
    );

    expect(find.text(AppConstants.login), findsOneWidget);
    expect(find.text(AppConstants.applyNow), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify navigation to login page', (WidgetTester tester) async {
    // AAA

    // Arrange

    // Act
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      ScreenUtilInit(
        child: MaterialApp.router(routerConfig: AppRouter.createRouter()),
      ),
    );

    await tester.tap(find.text(AppConstants.login));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(LoginPage), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
  testWidgets('Verify navigation to apply page', (WidgetTester tester) async {
    // AAA

    // Arrange

    // Act
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      ScreenUtilInit(
        child: MaterialApp.router(routerConfig: AppRouter.createRouter()),
      ),
    );

    await tester.tap(find.text(AppConstants.applyNow));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ApplyPage), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
