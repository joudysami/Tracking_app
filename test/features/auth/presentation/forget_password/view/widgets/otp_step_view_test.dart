import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/otp_step_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/resend_code_button.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_state.dart';

import '../forget_password_test_helpers.dart';

// Pinput's cursor blinks forever while focused, so these tests use timed
// pumps instead of pumpAndSettle.
void main() {
  const otpState = ForgetPasswordState(
    step: ForgetPasswordStep.otp,
    email: 'user@mail.com',
  );

  late FakeForgetPasswordViewModel viewModel;

  setUpAll(silenceLocalizationLogs);

  setUp(() => viewModel = FakeForgetPasswordViewModel(otpState));
  tearDown(() => viewModel.close());

  Finder resendButton() => find.descendant(
    of: find.byType(ResendCodeButton),
    matching: find.byType(TextButton),
  );

  Future<void> pump(WidgetTester tester) =>
      pumpStep(tester, viewModel: viewModel, step: const OtpStepView());

  testWidgets('renders title, subtitle, otp field and resend countdown',
      (tester) async {
    await pump(tester);

    expect(find.text(LocaleKeys.authOtpTitle), findsOneWidget);
    expect(find.text(LocaleKeys.authOtpSubtitle), findsOneWidget);
    expect(find.byType(Pinput), findsOneWidget);
    expect(find.text(LocaleKeys.authDidntReceiveCode), findsOneWidget);
    expect(find.text(LocaleKeys.authResendIn), findsOneWidget);
    expect(tester.widget<TextButton>(resendButton()).onPressed, isNull);
  });

  testWidgets('dispatches VerifyOtpEvent once all 6 digits are entered',
      (tester) async {
    await pump(tester);

    await tester.enterText(find.byType(Pinput), '123456');
    await tester.pump();

    expect(viewModel.events, hasLength(1));
    expect(
      viewModel.events.single,
      isA<VerifyOtpEvent>().having((e) => e.otp, 'otp', '123456'),
    );
  });

  testWidgets('does not dispatch anything for an incomplete otp',
      (tester) async {
    await pump(tester);

    await tester.enterText(find.byType(Pinput), '123');
    await tester.pump();

    expect(viewModel.events, isEmpty);
  });

  testWidgets('enables resend after the cooldown and dispatches ResendOtpEvent',
      (tester) async {
    await pump(tester);

    await tester.pump(const Duration(seconds: 30));

    expect(find.text(LocaleKeys.authResendCode), findsOneWidget);
    expect(tester.widget<TextButton>(resendButton()).onPressed, isNotNull);

    await tester.tap(resendButton());
    await tester.pump();

    expect(viewModel.events.single, isA<ResendOtpEvent>());
    expect(find.text(LocaleKeys.authResendIn), findsOneWidget);
  });

  testWidgets('shows the verifying indicator and disables input while loading',
      (tester) async {
    await pump(tester);

    viewModel.setState(otpState.copyWith(isLoading: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const ValueKey('verifying')), findsOneWidget);
    expect(find.text(LocaleKeys.commonLoading), findsOneWidget);
    expect(tester.widget<Pinput>(find.byType(Pinput)).enabled, isFalse);
  });

  testWidgets('keeps resend disabled while loading even after the cooldown',
      (tester) async {
    await pump(tester);
    await tester.pump(const Duration(seconds: 30));

    viewModel.setState(otpState.copyWith(isLoading: true));
    await tester.pump();

    expect(tester.widget<TextButton>(resendButton()).onPressed, isNull);
  });

  testWidgets('hides the verifying indicator when loading finishes',
      (tester) async {
    viewModel.setState(otpState.copyWith(isLoading: true));
    await pump(tester);

    viewModel.setState(otpState);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const ValueKey('verifying')), findsNothing);
    expect(tester.widget<Pinput>(find.byType(Pinput)).enabled, isTrue);
  });
}
