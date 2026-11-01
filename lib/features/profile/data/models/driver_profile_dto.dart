import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';

class DriverProfileDto {
  final String? vehicleTypeId;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? licenseFileName;

  const DriverProfileDto({
    this.vehicleTypeId,
    this.vehicleType,
    this.vehicleNumber,
    this.licenseFileName,
  });

  factory DriverProfileDto.fromJson(Map<String, dynamic> json) {
    final license = json['licenseDocument'] ?? json['vehicleLicense'];
    return DriverProfileDto(
      vehicleTypeId: json['vehicleTypeId']?.toString(),
      vehicleType: _text(json, 'vehicleTypeName', 'vehicleType'),
      vehicleNumber: _text(json, 'plateNumber', 'vehicleNumber'),
      licenseFileName: _fileName(license),
    );
  }

  VehicleInfoEntity toEntity() {
    return VehicleInfoEntity(
      vehicleTypeId: vehicleTypeId ?? '',
      vehicleType: vehicleType ?? '',
      vehicleNumber: vehicleNumber ?? '',
      licenseFileName: licenseFileName,
    );
  }
}

String? _text(Map<String, dynamic> json, String primary, String fallback) {
  return json[primary]?.toString() ?? json[fallback]?.toString();
}

String? _fileName(Object? license) {
  if (license is Map) return license['fileName']?.toString();
  if (license is! String || license.isEmpty) return null;
  return license.split(RegExp(r'[\\/]')).last;
}
