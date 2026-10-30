sealed class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class CurrentPasswordChanged extends ChangePasswordEvent {
  final String value;
  const CurrentPasswordChanged(this.value);
}

class NewPasswordChanged extends ChangePasswordEvent {
  final String value;
  const NewPasswordChanged(this.value);
}

class ConfirmPasswordChanged extends ChangePasswordEvent {
  final String value;
  const ConfirmPasswordChanged(this.value);
}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  const ChangePasswordSubmitted();
}
