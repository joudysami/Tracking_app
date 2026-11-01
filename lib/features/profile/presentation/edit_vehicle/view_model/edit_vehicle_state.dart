import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';

class EditVehicleState extends Equatable {
  final BaseState<VehicleInfoEntity> vehicle;
  final BaseState<List<VehicleTypeEntity>> types;
  final VehicleTypeEntity? selectedType;
  final String vehicleNumber;
  final String? licensePath;
  final String? licenseName;
  final bool isSubmitting;

  const EditVehicleState({
    this.vehicle = const BaseState(),
    this.types = const BaseState(),
    this.selectedType,
    this.vehicleNumber = '',
    this.licensePath,
    this.licenseName,
    this.isSubmitting = false,
  });

  bool get isLoading => vehicle.isLoading || types.isLoading;

  EditVehicleState copyWith({
    BaseState<VehicleInfoEntity>? vehicle,
    BaseState<List<VehicleTypeEntity>>? types,
    VehicleTypeEntity? selectedType,
    String? vehicleNumber,
    String? licensePath,
    String? licenseName,
    bool? isSubmitting,
  }) {
    return _copied(
      this,
      vehicle,
      types,
      selectedType,
      vehicleNumber,
      licensePath,
      licenseName,
      isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
    vehicle,
    types,
    selectedType,
    vehicleNumber,
    licensePath,
    licenseName,
    isSubmitting,
  ];
}

EditVehicleState _copied(
  EditVehicleState state,
  BaseState<VehicleInfoEntity>? vehicle,
  BaseState<List<VehicleTypeEntity>>? types,
  VehicleTypeEntity? selectedType,
  String? vehicleNumber,
  String? licensePath,
  String? licenseName,
  bool? isSubmitting,
) {
  return EditVehicleState(
    vehicle: vehicle ?? state.vehicle,
    types: types ?? state.types,
    selectedType: selectedType ?? state.selectedType,
    vehicleNumber: vehicleNumber ?? state.vehicleNumber,
    licensePath: licensePath ?? state.licensePath,
    licenseName: licenseName ?? state.licenseName,
    isSubmitting: isSubmitting ?? state.isSubmitting,
  );
}
