import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/resend_code_button.dart';

import '../forget_password_test_helpers.dart';

void main() {
  setUpAll(silenceLocalizationLogs);

  Future<void> pump(
    WidgetTester tester, {
    required VoidCallback onResend,
    bool enabled = true,
  }) async {
    await tester.pumpWidget(
      wrapWithApp(
        builder: () => Center(
          child: ResendCodeButton(
            onResend: onResend,
            enabled: enabled,
            cooldownSeconds: 3,
          ),
        ),
      ),
    );
  }

  TextButton button(WidgetTester tester) =>
      tester.widget<TextButton>(find.byType(TextButton));

  testWidgets('starts in cooldown with the button disabled', (tester) async {
    await pump(tester, onResend: () {});

    expect(find.text(LocaleKeys.authResendIn), findsOneWidget);
    expect(button(tester).onPressed, isNull);
  });

  testWidgets('stays disabled before the cooldown ends', (tester) async {
    await pump(tester, onResend: () {});

    await tester.pump(const Duration(seconds: 2));

    expect(find.text(LocaleKeys.authResendIn), findsOneWidget);
    expect(button(tester).onPressed, isNull);
  });

  testWidgets('becomes tappable after the cooldown ends', (tester) async {
    await pump(tester, onResend: () {});

    await tester.pump(const Duration(seconds: 3));

    expect(find.text(LocaleKeys.authResendCode), findsOneWidget);
    expect(button(tester).onPressed, isNotNull);
  });

  testWidgets('tapping calls onResend and restarts the cooldown',
      (tester) async {
    var calls = 0;
    await pump(tester, onResend: () => calls++);
    await tester.pump(const Duration(seconds: 3));

    await tester.tap(find.byType(TextButton));
    await tester.pump();

    expect(calls, 1);
    expect(find.text(LocaleKeys.authResendIn), findsOneWidget);
    expect(button(tester).onPressed, isNull);

    await tester.pump(const Duration(seconds: 3));
    expect(button(tester).onPressed, isNotNull);
  });

  testWidgets('stays disabled after the cooldown when not enabled',
      (tester) async {
    var calls = 0;
    await pump(tester, onResend: () => calls++, enabled: false);
    await tester.pump(const Duration(seconds: 3));

    expect(button(tester).onPressed, isNull);

    await tester.tap(find.byType(TextButton), warnIfMissed: false);
    expect(calls, 0);
  });
}
