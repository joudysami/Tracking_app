import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';

sealed class EditVehicleEvent {
  const EditVehicleEvent();
}

class EditVehicleStarted extends EditVehicleEvent {
  const EditVehicleStarted();
}

class VehicleTypeSelected extends EditVehicleEvent {
  final VehicleTypeEntity? value;
  const VehicleTypeSelected(this.value);
}

class VehicleNumberChanged extends EditVehicleEvent {
  final String value;
  const VehicleNumberChanged(this.value);
}

class LicensePickRequested extends EditVehicleEvent {
  const LicensePickRequested();
}

class UpdateVehicleRequested extends EditVehicleEvent {
  const UpdateVehicleRequested();
}
