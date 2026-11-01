import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_state.dart';

bool canUpdateVehicle(EditVehicleState state) {
  final saved = state.vehicle.data;
  if (state.isLoading || state.isSubmitting || saved == null) return false;
  if (state.selectedType == null) return false;
  if (AppValidators.validateVehicleNumber(state.vehicleNumber) != null) {
    return false;
  }
  return _dirty(state, saved);
}

bool _dirty(EditVehicleState state, VehicleInfoEntity saved) {
  final typeChanged = state.selectedType?.id != saved.vehicleTypeId;
  final numberChanged = state.vehicleNumber.trim() != saved.vehicleNumber;
  final licenseChanged =
      state.licensePath != null && state.licensePath!.isNotEmpty;
  return typeChanged || numberChanged || licenseChanged;
}
