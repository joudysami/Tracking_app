sealed class ForgetPasswordUiEvent {
  const ForgetPasswordUiEvent();
}

class ShowErrorUiEvent extends ForgetPasswordUiEvent {
  final String message;
  const ShowErrorUiEvent(this.message);
}

class OtpResentUiEvent extends ForgetPasswordUiEvent {
  const OtpResentUiEvent();
}

class NavigateToLoginUiEvent extends ForgetPasswordUiEvent {
  const NavigateToLoginUiEvent();
}