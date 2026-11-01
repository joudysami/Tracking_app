import 'package:tracking_app/features/auth/domain/entities/gender.dart';

sealed class EditProfileEvent {
  const EditProfileEvent();
}

class EditProfileStarted extends EditProfileEvent {
  const EditProfileStarted();
}

class FirstNameChanged extends EditProfileEvent {
  final String value;
  const FirstNameChanged(this.value);
}

class LastNameChanged extends EditProfileEvent {
  final String value;
  const LastNameChanged(this.value);
}

class EmailChanged extends EditProfileEvent {
  final String value;
  const EmailChanged(this.value);
}

class PhoneChanged extends EditProfileEvent {
  final String value;
  const PhoneChanged(this.value);
}

class GenderChanged extends EditProfileEvent {
  final Gender value;
  const GenderChanged(this.value);
}

class PhotoPickRequested extends EditProfileEvent {
  const PhotoPickRequested();
}

class UpdateProfileRequested extends EditProfileEvent {
  const UpdateProfileRequested();
}
