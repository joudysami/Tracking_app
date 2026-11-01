import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/profile_vehicle_type.dart';

VehicleTypeEntity? matchVehicleType(
  List<VehicleTypeEntity> types,
  VehicleInfoEntity? saved,
) {
  if (saved == null) return null;
  return _matchId(types, saved.vehicleTypeId) ??
      _matchName(types, saved.vehicleType);
}

VehicleTypeEntity? _matchId(List<VehicleTypeEntity> types, String id) {
  if (id.isEmpty) return null;
  for (final type in types) {
    if (type.id == id) return type;
  }
  return null;
}

VehicleTypeEntity? _matchName(List<VehicleTypeEntity> types, String raw) {
  if (raw.trim().isEmpty) return null;
  final wire = toProfileVehicleType(raw);
  for (final type in types) {
    if (toProfileVehicleType(type.name) == wire) return type;
  }
  return null;
}
