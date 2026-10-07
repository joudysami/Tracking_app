// presentation/forget_password/cubit/forget_password_state.dart
import 'package:equatable/equatable.dart';

enum ForgetPasswordStep { email, otp, resetPassword }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStep step;
  final bool isLoading;
  final String email;
  final String otpToken;

  const ForgetPasswordState({
    this.step = ForgetPasswordStep.email,
    this.isLoading = false,
    this.email = '',
    this.otpToken = '',
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStep? step,
    bool? isLoading,
    String? email,
    String? otpToken,
  }) {
    return ForgetPasswordState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      otpToken: otpToken ?? this.otpToken,
    );
  }

  @override
  List<Object?> get props => [step, isLoading, email, otpToken];
}