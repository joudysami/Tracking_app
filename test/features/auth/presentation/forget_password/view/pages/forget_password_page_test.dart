import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:pinput/pinput.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/page/forget_password_page.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/email_step_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/otp_step_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/widgets/reset_password_step_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';

import '../forget_password_test_helpers.dart';
import '../forget_password_test_helpers.mocks.dart';

// The OTP step autofocuses a Pinput whose cursor blinks forever, so these
// tests use timed pumps instead of pumpAndSettle.
void main() {
  const email = 'user@mail.com';
  const otp = '123456';
  const password = 'Password1';
  const loginScreenText = 'login-screen';

  late MockForgetPasswordUseCase forgetPasswordUseCase;
  late MockVerifyOtpUseCase verifyOtpUseCase;
  late MockResetPasswordUseCase resetPasswordUseCase;

  setUpAll(() {
    silenceLocalizationLogs();
    provideDummy<BaseResponse<void>>(const SuccessResponse<void>(null));
    provideDummy<BaseResponse<VerifyOtpResponse>>(
      const SuccessResponse<VerifyOtpResponse>(null),
    );
  });

  setUp(() {
    forgetPasswordUseCase = MockForgetPasswordUseCase();
    verifyOtpUseCase = MockVerifyOtpUseCase();
    resetPasswordUseCase = MockResetPasswordUseCase();

    getIt.registerFactory<ForgetPasswordViewModel>(
      () => ForgetPasswordViewModel(
        forgetPasswordUseCase,
        verifyOtpUseCase,
        resetPasswordUseCase,
      ),
    );
  });

  tearDown(() => getIt.reset());

  ErrorResponse<T> failure<T>(String message) =>
      ErrorResponse<T>(appError: BadResponseError(message));

  void stubSendEmail(BaseResponse<void> response) {
    when(forgetPasswordUseCase(request: anyNamed('request')))
        .thenAnswer((_) async => response);
  }

  void stubVerifyOtp(BaseResponse<VerifyOtpResponse> response) {
    when(verifyOtpUseCase(request: anyNamed('request')))
        .thenAnswer((_) async => response);
  }

  void stubResetPassword(BaseResponse<void> response) {
    when(resetPasswordUseCase(request: anyNamed('request')))
        .thenAnswer((_) async => response);
  }

  const verifySuccess = SuccessResponse<VerifyOtpResponse>(
    VerifyOtpResponse(otpToken: 'token-1', expiresInMinutes: 30),
  );

  Future<void> pumpPage(WidgetTester tester) async {
    usePhoneScreen(tester);
    final router = GoRouter(
      initialLocation: AppRoutes.forgetPassword,
      routes: [
        GoRoute(
          path: AppRoutes.forgetPassword,
          builder: (_, _) => const ForgetPasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, _) =>
              const Scaffold(body: Center(child: Text(loginScreenText))),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (_, _) => MaterialApp.router(
          theme: AppTheme(LightThemeColor()).themeData,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
  }

  /// Lets the use case future resolve and the AnimatedSwitcher finish.
  Future<void> settleStep(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> submitEmail(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField), email);
    await tester.tap(
      find.widgetWithText(ElevatedButton, LocaleKeys.commonContinue),
    );
    await settleStep(tester);
  }

  Future<void> submitOtp(WidgetTester tester) async {
    await tester.enterText(find.byType(Pinput), otp);
    await settleStep(tester);
  }

  Future<void> submitNewPassword(WidgetTester tester) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, LocaleKeys.authNewPassword),
      password,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, LocaleKeys.authConfirmPassword),
      password,
    );
    await tester.tap(
      find.widgetWithText(ElevatedButton, LocaleKeys.commonConfirm),
    );
    await settleStep(tester);
  }

  Future<void> tapBack(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton));
    await settleStep(tester);
  }

  Finder snackBarWithText(String text) =>
      find.descendant(of: find.byType(SnackBar), matching: find.text(text));

  testWidgets('starts on the email step', (tester) async {
    await pumpPage(tester);

    expect(find.text(LocaleKeys.authPassword), findsOneWidget);
    expect(find.byType(EmailStepView), findsOneWidget);
    expect(find.byType(OtpStepView), findsNothing);
    expect(find.byType(ResetPasswordStepView), findsNothing);
  });

  testWidgets('completes the whole flow and lands on the login screen',
      (tester) async {
    stubSendEmail(const SuccessResponse<void>(null));
    stubVerifyOtp(verifySuccess);
    stubResetPassword(const SuccessResponse<void>(null));
    await pumpPage(tester);

    await submitEmail(tester);
    expect(find.byType(OtpStepView), findsOneWidget);
    verify(forgetPasswordUseCase(
      request: const ForgetPasswordRequest(email: email),
    )).called(1);

    await submitOtp(tester);
    expect(find.byType(ResetPasswordStepView), findsOneWidget);
    verify(verifyOtpUseCase(
      request: const VerifyOtpRequest(email: email, otp: otp),
    )).called(1);

    await submitNewPassword(tester);
    verify(resetPasswordUseCase(
      request: const ResetPasswordRequest(
        otpToken: 'token-1',
        password: password,
        confirmPassword: password,
      ),
    )).called(1);

    expect(find.text(loginScreenText), findsOneWidget);
    expect(find.byType(ForgetPasswordPage), findsNothing);
  });

  testWidgets('shows the button loader while the email request is pending',
      (tester) async {
    final completer = Completer<BaseResponse<void>>();
    when(forgetPasswordUseCase(request: anyNamed('request')))
        .thenAnswer((_) => completer.future);
    await pumpPage(tester);

    await tester.enterText(find.byType(TextFormField), email);
    await tester.tap(
      find.widgetWithText(ElevatedButton, LocaleKeys.commonContinue),
    );
    await tester.pump();

    final continueButton =
        find.widgetWithText(ElevatedButton, LocaleKeys.commonContinue);
    expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNull);
    expect(
      find.descendant(
        of: continueButton,
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );

    completer.complete(const SuccessResponse<void>(null));
    await settleStep(tester);
    expect(find.byType(OtpStepView), findsOneWidget);
  });

  testWidgets('shows the error in a snackbar and stays on email on failure',
      (tester) async {
    stubSendEmail(failure<void>('Email not found'));
    await pumpPage(tester);

    await submitEmail(tester);

    expect(snackBarWithText('Email not found'), findsOneWidget);
    expect(find.byType(EmailStepView), findsOneWidget);
    expect(find.byType(OtpStepView), findsNothing);
  });

  testWidgets('shows the error in a snackbar and stays on otp when invalid',
      (tester) async {
    stubSendEmail(const SuccessResponse<void>(null));
    stubVerifyOtp(failure<VerifyOtpResponse>('Invalid OTP'));
    await pumpPage(tester);
    await submitEmail(tester);

    await submitOtp(tester);

    expect(snackBarWithText('Invalid OTP'), findsOneWidget);
    expect(find.byType(OtpStepView), findsOneWidget);
    expect(find.byType(ResetPasswordStepView), findsNothing);
  });

  testWidgets('shows the error in a snackbar when resetting fails',
      (tester) async {
    stubSendEmail(const SuccessResponse<void>(null));
    stubVerifyOtp(verifySuccess);
    stubResetPassword(failure<void>('Token expired'));
    await pumpPage(tester);
    await submitEmail(tester);
    await submitOtp(tester);

    await submitNewPassword(tester);

    expect(snackBarWithText('Token expired'), findsOneWidget);
    expect(find.byType(ResetPasswordStepView), findsOneWidget);
    expect(find.text(loginScreenText), findsNothing);
  });

  testWidgets('resending the code shows a confirmation snackbar',
      (tester) async {
    stubSendEmail(const SuccessResponse<void>(null));
    await pumpPage(tester);
    await submitEmail(tester);

    await tester.pump(const Duration(seconds: 30));
    await tester.tap(find.text(LocaleKeys.authResendCode));
    await settleStep(tester);

    expect(snackBarWithText(LocaleKeys.authCodeResent), findsOneWidget);
    expect(find.byType(OtpStepView), findsOneWidget);
    verify(forgetPasswordUseCase(
      request: const ForgetPasswordRequest(email: email),
    )).called(2);
  });

  testWidgets('back on the otp step returns to email with the email kept',
      (tester) async {
    stubSendEmail(const SuccessResponse<void>(null));
    await pumpPage(tester);
    await submitEmail(tester);

    await tapBack(tester);

    expect(find.byType(EmailStepView), findsOneWidget);
    expect(find.byType(OtpStepView), findsNothing);
    expect(find.text(email), findsOneWidget);
  });

  testWidgets('back on the reset step returns to the otp step',
      (tester) async {
    stubSendEmail(const SuccessResponse<void>(null));
    stubVerifyOtp(verifySuccess);
    await pumpPage(tester);
    await submitEmail(tester);
    await submitOtp(tester);

    await tapBack(tester);

    expect(find.byType(OtpStepView), findsOneWidget);
    expect(find.byType(ResetPasswordStepView), findsNothing);
  });

  testWidgets('back on the email step goes to login when nothing to pop',
      (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text(loginScreenText), findsOneWidget);
  });

  testWidgets('system back on the otp step goes back a step, not a page',
      (tester) async {
    stubSendEmail(const SuccessResponse<void>(null));
    await pumpPage(tester);
    await submitEmail(tester);

    await tester.binding.handlePopRoute();
    await settleStep(tester);

    expect(find.byType(EmailStepView), findsOneWidget);
    expect(find.byType(ForgetPasswordPage), findsOneWidget);
  });
}
