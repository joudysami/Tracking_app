sealed class ProfileEvent {
  const ProfileEvent();
}

class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

class LogoutConfirmed extends ProfileEvent {
  const LogoutConfirmed();
}
