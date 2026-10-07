import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';

import 'forget_password_test_helpers.mocks.dart';

/// Records dispatched events instead of running them, and lets tests
/// drive the state directly.
@GenerateNiceMocks([
  MockSpec<ForgetPasswordUseCase>(),
  MockSpec<VerifyOtpUseCase>(),
  MockSpec<ResetPasswordUseCase>(),
])
class FakeForgetPasswordViewModel extends ForgetPasswordViewModel {
  FakeForgetPasswordViewModel([
    ForgetPasswordState initialState = const ForgetPasswordState(),
  ]) : super(
         MockForgetPasswordUseCase(),
         MockVerifyOtpUseCase(),
         MockResetPasswordUseCase(),
       ) {
    emit(initialState);
  }

  final List<ForgetPasswordEvent> events = [];

  @override
  void onEvent(ForgetPasswordEvent event) => events.add(event);

  void setState(ForgetPasswordState state) => emit(state);
}

/// Silences easy_localization's "missing key" warnings. Without loaded
/// translations, `tr()` returns the key itself, so tests assert on keys.
void silenceLocalizationLogs() {
  EasyLocalization.logger.enableBuildModes = [];
}

/// Gives the test a 720x1560 logical screen (phone aspect ratio). The test
/// font draws every glyph as a full square and untranslated keys are long,
/// so unscaled text rows overflow on a real phone width.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(2160, 4680);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Widget wrapWithApp({required Widget Function() builder}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (_, _) => MaterialApp(
      theme: AppTheme(LightThemeColor()).themeData,
      home: Scaffold(body: builder()),
    ),
  );
}

Future<void> pumpStep(
  WidgetTester tester, {
  required ForgetPasswordViewModel viewModel,
  required Widget step,
}) async {
  usePhoneScreen(tester);
  await tester.pumpWidget(
    wrapWithApp(
      builder: () => BlocProvider.value(value: viewModel, child: step),
    ),
  );
  await tester.pump();
}
