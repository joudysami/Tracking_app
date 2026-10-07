import 'package:equatable/equatable.dart';

class ResetPasswordRequest extends Equatable {
  final String? otpToken;
  final String? password;
  final String? confirmPassword;

  const ResetPasswordRequest ({
    this.otpToken,
    this.password,
    this.confirmPassword,
  });

  @override
  List<Object?> get props => [otpToken, password, confirmPassword];
}


