import 'package:equatable/equatable.dart';

class VehicleInfoEntity extends Equatable {
  final String vehicleTypeId;
  final String vehicleType;
  final String vehicleNumber;
  final String? licenseFileName;

  const VehicleInfoEntity({
    required this.vehicleTypeId,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.licenseFileName,
  });

  @override
  List<Object?> get props => [
    vehicleTypeId,
    vehicleType,
    vehicleNumber,
    licenseFileName,
  ];
}
