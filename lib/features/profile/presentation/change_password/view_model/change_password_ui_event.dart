sealed class ChangePasswordUiEvent {
  const ChangePasswordUiEvent();
}

class ShowChangePasswordError extends ChangePasswordUiEvent {
  final String message;
  const ShowChangePasswordError(this.message);
}

class PasswordChanged extends ChangePasswordUiEvent {
  const PasswordChanged();
}
