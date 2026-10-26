sealed class EditVehicleUiEvent {
  const EditVehicleUiEvent();
}

class ShowEditVehicleError extends EditVehicleUiEvent {
  final String message;
  const ShowEditVehicleError(this.message);
}

class VehicleSaved extends EditVehicleUiEvent {
  const VehicleSaved();
}
