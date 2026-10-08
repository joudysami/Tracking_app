import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/widgets/app_otp_field.dart';

void main() {
  Future<void> pump(WidgetTester tester, AppOtpField field) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => MaterialApp(
          theme: AppTheme(LightThemeColor()).themeData,
          home: Scaffold(body: Center(child: field)),
        ),
      ),
    );
  }

  Pinput pinput(WidgetTester tester) =>
      tester.widget<Pinput>(find.byType(Pinput));

  testWidgets('has 6 slots by default', (tester) async {
    await pump(tester, const AppOtpField());

    expect(pinput(tester).length, 6);
  });

  testWidgets('uses the given pinWidth for every pin theme', (tester) async {
    await pump(tester, const AppOtpField(pinWidth: 40));

    final field = pinput(tester);
    expect(field.defaultPinTheme?.width, 40);
    expect(field.focusedPinTheme?.width, 40);
    expect(field.errorPinTheme?.width, 40);
  });

  testWidgets('forwards the completed code', (tester) async {
    String? completed;
    await pump(tester, AppOtpField(onCompleted: (v) => completed = v));

    await tester.enterText(find.byType(Pinput), 'A1B2C3');
    await tester.pump();

    expect(completed, 'A1B2C3');
  });

  testWidgets('shows the error text when given', (tester) async {
    await pump(tester, const AppOtpField(errorText: 'Invalid code'));

    expect(find.text('Invalid code'), findsOneWidget);
  });
}
