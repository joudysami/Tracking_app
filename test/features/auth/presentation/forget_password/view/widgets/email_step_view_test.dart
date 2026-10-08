import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/email_step_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_state.dart';

import '../forget_password_test_helpers.dart';

void main() {
  late FakeForgetPasswordViewModel viewModel;

  setUpAll(silenceLocalizationLogs);

  setUp(() => viewModel = FakeForgetPasswordViewModel());
  tearDown(() => viewModel.close());

  Finder emailField() => find.byType(TextFormField);
  Finder continueButton() =>
      find.widgetWithText(ElevatedButton, LocaleKeys.commonContinue);

  Future<void> pump(WidgetTester tester) =>
      pumpStep(tester, viewModel: viewModel, step: const EmailStepView());

  testWidgets('renders title, description, email field and continue button',
      (tester) async {
    await pump(tester);

    expect(find.text(LocaleKeys.authForgotPassword), findsOneWidget);
    expect(find.text(LocaleKeys.authForgotPasswordDesc), findsOneWidget);
    expect(find.text(LocaleKeys.authEmail), findsOneWidget);
    expect(emailField(), findsOneWidget);
    expect(continueButton(), findsOneWidget);
  });

  testWidgets('pre-fills the email stored in the state', (tester) async {
    viewModel.setState(const ForgetPasswordState(email: 'saved@mail.com'));
    await pump(tester);

    expect(find.text('saved@mail.com'), findsOneWidget);
  });

  testWidgets('shows required error and dispatches nothing when empty',
      (tester) async {
    await pump(tester);

    await tester.tap(continueButton());
    await tester.pump();

    expect(find.text(LocaleKeys.validationPleaseEnterYourEmail), findsOneWidget);
    expect(viewModel.events, isEmpty);
  });

  testWidgets('shows invalid email error for a malformed email',
      (tester) async {
    await pump(tester);

    await tester.enterText(emailField(), 'not-an-email');
    await tester.tap(continueButton());
    await tester.pump();

    expect(
      find.text(LocaleKeys.validationPleaseEnterValidEmail),
      findsOneWidget,
    );
    expect(viewModel.events, isEmpty);
  });

  testWidgets('dispatches SendEmailEvent with the trimmed email',
      (tester) async {
    await pump(tester);

    await tester.enterText(emailField(), '  user@mail.com  ');
    await tester.tap(continueButton());
    await tester.pump();

    expect(viewModel.events, hasLength(1));
    expect(
      viewModel.events.single,
      isA<SendEmailEvent>().having((e) => e.email, 'email', 'user@mail.com'),
    );
  });

  testWidgets('disables the button and locks the field while loading',
      (tester) async {
    viewModel.setState(const ForgetPasswordState(isLoading: true));
    await pump(tester);

    final button = tester.widget<ElevatedButton>(continueButton());
    expect(button.onPressed, isNull);
    expect(
      find.descendant(
        of: continueButton(),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );

    final field = tester.widget<EditableText>(
      find.descendant(of: emailField(), matching: find.byType(EditableText)),
    );
    expect(field.readOnly, isTrue);
  });

  testWidgets('re-enables the button once loading finishes', (tester) async {
    viewModel.setState(const ForgetPasswordState(isLoading: true));
    await pump(tester);

    viewModel.setState(const ForgetPasswordState());
    await tester.pump();

    expect(tester.widget<ElevatedButton>(continueButton()).onPressed, isNotNull);
  });
}
