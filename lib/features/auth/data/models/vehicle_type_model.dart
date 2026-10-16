import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';

part 'vehicle_type_model.g.dart';

@JsonSerializable()
class VehicleTypeModel {
  final String? id;
  final String? name;

  VehicleTypeModel({this.id, this.name});

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleTypeModelToJson(this);

  VehicleTypeEntity toDomain() =>
      VehicleTypeEntity(id: id ?? '', name: name ?? '');
}
