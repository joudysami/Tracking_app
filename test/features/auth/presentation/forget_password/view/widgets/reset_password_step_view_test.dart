import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/reset_password_step_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_state.dart';

import '../forget_password_test_helpers.dart';

void main() {
  const resetState = ForgetPasswordState(
    step: ForgetPasswordStep.resetPassword,
    email: 'user@mail.com',
    otpToken: 'token-1',
  );

  late FakeForgetPasswordViewModel viewModel;

  setUpAll(silenceLocalizationLogs);

  setUp(() => viewModel = FakeForgetPasswordViewModel(resetState));
  tearDown(() => viewModel.close());

  Finder passwordField() =>
      find.widgetWithText(TextFormField, LocaleKeys.authNewPassword);
  // Label and hint share the same key, so the field matches twice.
  Finder confirmField() =>
      find.widgetWithText(TextFormField, LocaleKeys.authConfirmPassword).first;
  Finder confirmButton() =>
      find.widgetWithText(ElevatedButton, LocaleKeys.commonConfirm);

  EditableText editableOf(WidgetTester tester, Finder field) =>
      tester.widget<EditableText>(
        find.descendant(of: field, matching: find.byType(EditableText)),
      );

  Future<void> pump(WidgetTester tester) => pumpStep(
    tester,
    viewModel: viewModel,
    step: const ResetPasswordStepView(),
  );

  Future<void> fillAndSubmit(
    WidgetTester tester, {
    required String password,
    required String confirm,
  }) async {
    await tester.enterText(passwordField(), password);
    await tester.enterText(confirmField(), confirm);
    await tester.tap(confirmButton());
    await tester.pump();
  }

  testWidgets('renders title, both password fields and confirm button',
      (tester) async {
    await pump(tester);

    expect(find.text(LocaleKeys.authResetPassword), findsOneWidget);
    expect(
      find.text(LocaleKeys.validationResetPasswordRequirement),
      findsOneWidget,
    );
    expect(passwordField(), findsOneWidget);
    expect(confirmField(), findsOneWidget);
    expect(confirmButton(), findsOneWidget);
  });

  testWidgets('both fields are obscured by default', (tester) async {
    await pump(tester);

    expect(editableOf(tester, passwordField()).obscureText, isTrue);
    expect(editableOf(tester, confirmField()).obscureText, isTrue);
  });

  testWidgets('visibility icon toggles password obscuring', (tester) async {
    await pump(tester);

    await tester.tap(
      find.descendant(
        of: passwordField(),
        matching: find.byIcon(Icons.visibility_off),
      ),
    );
    await tester.pump();

    expect(editableOf(tester, passwordField()).obscureText, isFalse);
    expect(editableOf(tester, confirmField()).obscureText, isTrue);
  });

  testWidgets('shows required errors when submitted empty', (tester) async {
    await pump(tester);

    await tester.tap(confirmButton());
    await tester.pump();

    expect(find.text(LocaleKeys.validationPasswordIsRequired), findsOneWidget);
    expect(
      find.text(LocaleKeys.validationConfirmPasswordIsRequired),
      findsOneWidget,
    );
    expect(viewModel.events, isEmpty);
  });

  testWidgets('rejects a password that does not meet the requirements',
      (tester) async {
    await pump(tester);

    await fillAndSubmit(tester, password: 'weak', confirm: 'weak');

    expect(find.text(LocaleKeys.validationPasswordRequirement), findsOneWidget);
    expect(viewModel.events, isEmpty);
  });

  testWidgets('rejects mismatching passwords', (tester) async {
    await pump(tester);

    await fillAndSubmit(tester, password: 'Password1', confirm: 'Password2');

    expect(find.text(LocaleKeys.validationPasswordsDoNotMatch), findsOneWidget);
    expect(viewModel.events, isEmpty);
  });

  testWidgets('dispatches ResetPasswordEvent with valid matching passwords',
      (tester) async {
    await pump(tester);

    await fillAndSubmit(tester, password: 'Password1', confirm: 'Password1');

    expect(viewModel.events, hasLength(1));
    expect(
      viewModel.events.single,
      isA<ResetPasswordEvent>()
          .having((e) => e.password, 'password', 'Password1')
          .having((e) => e.confirmPassword, 'confirmPassword', 'Password1'),
    );
  });

  testWidgets('disables the button and locks fields while loading',
      (tester) async {
    viewModel.setState(resetState.copyWith(isLoading: true));
    await pump(tester);

    expect(tester.widget<ElevatedButton>(confirmButton()).onPressed, isNull);
    expect(editableOf(tester, passwordField()).readOnly, isTrue);
    expect(editableOf(tester, confirmField()).readOnly, isTrue);
  });
}
