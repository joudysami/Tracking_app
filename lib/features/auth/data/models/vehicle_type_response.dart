import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_model.dart';

part 'vehicle_type_response.g.dart';

@JsonSerializable()
class VehicleTypesResponse {
  final bool? status;
  final int? code;
  final String? message;
  final List<VehicleTypeModel>? data; 
  
  VehicleTypesResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory VehicleTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleTypesResponseToJson(this);
}
