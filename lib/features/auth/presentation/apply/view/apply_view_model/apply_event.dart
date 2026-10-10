import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';

sealed class ApplyEvent {}

class VehicleTypesRequested extends ApplyEvent {}

class FirstNameChanged extends ApplyEvent {
  final String value;

  FirstNameChanged(this.value);
}

class LastNameChanged extends ApplyEvent {
  final String value;

  LastNameChanged(this.value);
}

class VehicleTypeChanged extends ApplyEvent {
  final VehicleTypeEntity? value;

  VehicleTypeChanged(this.value);
}

class PlateNumberChanged extends ApplyEvent {
  final String value;

  PlateNumberChanged(this.value);
}

class EmailChanged extends ApplyEvent {
  final String value;

  EmailChanged(this.value);
}

class PhoneChanged extends ApplyEvent {
  final String value;

  PhoneChanged(this.value);
}

class NidChanged extends ApplyEvent {
  final String value;

  NidChanged(this.value);
}

class PasswordChanged extends ApplyEvent {
  final String value;

  PasswordChanged(this.value);
}

class ConfirmPasswordChanged extends ApplyEvent {
  final String value;

  ConfirmPasswordChanged(this.value);
}

class GenderChanged extends ApplyEvent {
  final Gender value;

  GenderChanged(this.value);
}

class PickLicenseImageRequested extends ApplyEvent {}

class PickIdImageRequested extends ApplyEvent {}

class ApplyRequested extends ApplyEvent {}
