import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/on_bording/presentation/page/on_bording_page.dart';

void main() {
  testWidgets('App smoke test - Onboarding page renders successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        child: const MaterialApp(
          home: OnBordingPage(),
        ),
      ),
    );
    expect(find.byType(OnBordingPage), findsOneWidget);
  });
}
