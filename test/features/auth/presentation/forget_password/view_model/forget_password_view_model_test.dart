import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_ui_event.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'forget_password_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ForgetPasswordUseCase>(),
  MockSpec<VerifyOtpUseCase>(),
  MockSpec<ResetPasswordUseCase>(),
])
void main() {
  late MockForgetPasswordUseCase forgetPasswordUseCase;
  late MockVerifyOtpUseCase verifyOtpUseCase;
  late MockResetPasswordUseCase resetPasswordUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<void>>(const SuccessResponse<void>(null));
    provideDummy<BaseResponse<VerifyOtpResponse>>(
      const SuccessResponse<VerifyOtpResponse>(null),
    );
  });

  setUp(() {
    forgetPasswordUseCase = MockForgetPasswordUseCase();
    verifyOtpUseCase = MockVerifyOtpUseCase();
    resetPasswordUseCase = MockResetPasswordUseCase();
  });

  ForgetPasswordViewModel buildCubit() => ForgetPasswordViewModel(
    forgetPasswordUseCase,
    verifyOtpUseCase,
    resetPasswordUseCase,
  );

  void stubForgetPassword(BaseResponse<void> response) {
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

  ErrorResponse<T> failure<T>(String message) =>
      ErrorResponse<T>(appError: BadResponseError(message));

  test('initial state is the email step', () {
    expect(buildCubit().state, const ForgetPasswordState());
  });

  group('SendEmailEvent', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'moves to the otp step and stores the email on success',
      build: () {
        stubForgetPassword(const SuccessResponse<void>(null));
        return buildCubit();
      },
      act: (c) => c.onEvent(const SendEmailEvent('a@b.com')),
      expect: () => const [
        ForgetPasswordState(isLoading: true),
        ForgetPasswordState(step: ForgetPasswordStep.otp, email: 'a@b.com'),
      ],
      verify: (_) {
        verify(forgetPasswordUseCase(
          request: const ForgetPasswordRequest(email: 'a@b.com'),
        )).called(1);
      },
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'stays on the email step on failure',
      build: () {
        stubForgetPassword(failure<void>('Invalid email'));
        return buildCubit();
      },
      act: (c) => c.onEvent(const SendEmailEvent('a@b.com')),
      expect: () => const [
        ForgetPasswordState(isLoading: true),
        ForgetPasswordState(),
      ],
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'ignores the event while already loading',
      build: buildCubit,
      seed: () => const ForgetPasswordState(isLoading: true),
      act: (c) => c.onEvent(const SendEmailEvent('a@b.com')),
      expect: () => const <ForgetPasswordState>[],
      verify: (_) {
        verifyNever(forgetPasswordUseCase(request: anyNamed('request')));
      },
    );
  });

  group('VerifyOtpEvent', () {
    const otpStep = ForgetPasswordState(
      step: ForgetPasswordStep.otp,
      email: 'a@b.com',
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'moves to reset step and keeps the otpToken on success',
      build: () {
        stubVerifyOtp(const SuccessResponse<VerifyOtpResponse>(
          VerifyOtpResponse(otpToken: 'token-1', expiresInMinutes: 30),
        ));
        return buildCubit();
      },
      seed: () => otpStep,
      act: (c) => c.onEvent(const VerifyOtpEvent('123456')),
      expect: () => const [
        ForgetPasswordState(
          step: ForgetPasswordStep.otp,
          email: 'a@b.com',
          isLoading: true,
        ),
        ForgetPasswordState(
          step: ForgetPasswordStep.resetPassword,
          email: 'a@b.com',
          otpToken: 'token-1',
        ),
      ],
      verify: (_) {
        verify(verifyOtpUseCase(
          request: const VerifyOtpRequest(email: 'a@b.com', otp: '123456'),
        )).called(1);

      },
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'stays on the otp step on failure',
      build: () {
        stubVerifyOtp(failure<VerifyOtpResponse>('Invalid OTP'));
        return buildCubit();
      },
      seed: () => otpStep,
      act: (c) => c.onEvent(const VerifyOtpEvent('000000')),
      expect: () => const [
        ForgetPasswordState(
          step: ForgetPasswordStep.otp,
          email: 'a@b.com',
          isLoading: true,
        ),
        ForgetPasswordState(step: ForgetPasswordStep.otp, email: 'a@b.com'),
      ],
    );
  });

  group('ResendOtpEvent', () {
    const otpStep = ForgetPasswordState(
      step: ForgetPasswordStep.otp,
      email: 'a@b.com',
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'resends using the stored email and stays on the otp step',
      build: () {
        stubForgetPassword(const SuccessResponse<void>(null));
        return buildCubit();
      },
      seed: () => otpStep,
      act: (c) => c.onEvent(const ResendOtpEvent()),
      expect: () => const [
        ForgetPasswordState(
          step: ForgetPasswordStep.otp,
          email: 'a@b.com',
          isLoading: true,
        ),
        ForgetPasswordState(step: ForgetPasswordStep.otp, email: 'a@b.com'),
      ],
      verify: (_) {
        verify(forgetPasswordUseCase(
          request: const ForgetPasswordRequest(email: 'a@b.com'),
        )).called(1);
      },
    );
  });

  group('ResetPasswordEvent', () {
    const resetStep = ForgetPasswordState(
      step: ForgetPasswordStep.resetPassword,
      email: 'a@b.com',
      otpToken: 'token-1',
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'sends the stored otpToken with the passwords',
      build: () {
        stubResetPassword(const SuccessResponse<void>(null));
        return buildCubit();
      },
      seed: () => resetStep,
      act: (c) => c.onEvent(const ResetPasswordEvent(
        password: 'Abcdef1',
        confirmPassword: 'Abcdef1',
      )),
      expect: () => [
        resetStep.copyWith(isLoading: true),
        resetStep,
      ],
      verify: (_) {
        verify(resetPasswordUseCase(
          request: const ResetPasswordRequest(
            otpToken: 'token-1',
            password: 'Abcdef1',
            confirmPassword: 'Abcdef1',
          ),
        )).called(1);
      },
    );
  });

  group('GoBackEvent', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'otp -> email',
      build: buildCubit,
      seed: () => const ForgetPasswordState(step: ForgetPasswordStep.otp),
      act: (c) => c.onEvent(const GoBackEvent()),
      expect: () => const [ForgetPasswordState()],
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'resetPassword -> otp',
      build: buildCubit,
      seed: () =>
      const ForgetPasswordState(step: ForgetPasswordStep.resetPassword),
      act: (c) => c.onEvent(const GoBackEvent()),
      expect: () => const [ForgetPasswordState(step: ForgetPasswordStep.otp)],
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'does nothing on the email step',
      build: buildCubit,
      act: (c) => c.onEvent(const GoBackEvent()),
      expect: () => const <ForgetPasswordState>[],
    );
  });

  group('ui events', () {
    late ForgetPasswordViewModel cubit;
    late List<ForgetPasswordUiEvent> events;

    setUp(() {
      cubit = buildCubit();
      events = [];
      cubit.uiEvents.listen(events.add);
    });

    tearDown(() => cubit.close());

    Future<void> pump() => Future<void>.delayed(Duration.zero);

    test('ShowErrorUiEvent carries the error message when sending email fails',
            () async {
          stubForgetPassword(failure<void>('Invalid email'));

          cubit.onEvent(const SendEmailEvent('a@b.com'));
          await pump();

          expect(events, hasLength(1));
          expect(
            events.single,
            isA<ShowErrorUiEvent>()
                .having((e) => e.message, 'message', 'Invalid email'),
          );
        });

    test('ShowErrorUiEvent is emitted when verifying the otp fails', () async {
      stubVerifyOtp(failure<VerifyOtpResponse>('Invalid OTP'));

      cubit.onEvent(const VerifyOtpEvent('000000'));
      await pump();

      expect(
        events.single,
        isA<ShowErrorUiEvent>()
            .having((e) => e.message, 'message', 'Invalid OTP'),
      );
    });

    test('OtpResentUiEvent is emitted after a successful resend', () async {
      stubForgetPassword(const SuccessResponse<void>(null));

      cubit.onEvent(const ResendOtpEvent());
      await pump();

      expect(events.single, isA<OtpResentUiEvent>());
    });

    test('NavigateToLoginUiEvent is emitted after a successful reset',
            () async {
          stubResetPassword(const SuccessResponse<void>(null));

          cubit.onEvent(const ResetPasswordEvent(
            password: 'Abcdef1',
            confirmPassword: 'Abcdef1',
          ));
          await pump();

          expect(events.single, isA<NavigateToLoginUiEvent>());
        });

    test('no ui event is emitted when sending email succeeds', () async {
      stubForgetPassword(const SuccessResponse<void>(null));

      cubit.onEvent(const SendEmailEvent('a@b.com'));
      await pump();

      expect(events, isEmpty);
    });
  });
}