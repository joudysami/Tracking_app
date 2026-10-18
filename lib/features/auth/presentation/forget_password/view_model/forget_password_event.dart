sealed class ForgetPasswordEvent {
  const ForgetPasswordEvent();
}

class SendEmailEvent extends ForgetPasswordEvent {
  final String email;
  const SendEmailEvent(this.email);
}

class VerifyOtpEvent extends ForgetPasswordEvent {
  final String otp;
  const VerifyOtpEvent(this.otp);
}

class ResendOtpEvent extends ForgetPasswordEvent {
  const ResendOtpEvent();
}

class ResetPasswordEvent extends ForgetPasswordEvent {
  final String password;
  final String confirmPassword;
  const ResetPasswordEvent({
    required this.password,
    required this.confirmPassword,
  });
}

class GoBackEvent extends ForgetPasswordEvent {
  const GoBackEvent();
}