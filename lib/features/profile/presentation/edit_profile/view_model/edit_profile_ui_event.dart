sealed class EditProfileUiEvent {
  const EditProfileUiEvent();
}

class ShowEditProfileError extends EditProfileUiEvent {
  final String message;
  const ShowEditProfileError(this.message);
}

class EditProfileSaved extends EditProfileUiEvent {
  const EditProfileSaved();
}
