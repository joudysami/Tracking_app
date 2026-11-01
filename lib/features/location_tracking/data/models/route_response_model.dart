import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/route_entity.dart';

part 'route_response_model.g.dart';

@JsonSerializable()
class RouteResponseModel {
  final String code;
  final List<RouteItemModel> routes;

  const RouteResponseModel({required this.code, required this.routes});

  factory RouteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RouteResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteResponseModelToJson(this);

  RouteEntity toDomain() {
    if (routes.isEmpty) {
      throw const FormatException('No route found');
    }

    final coordinates = routes.first.geometry.coordinates;

    return RouteEntity(
      points: coordinates
          .map(
            (coordinate) => RoutePointEntity(
              longitude: coordinate[0],
              latitude: coordinate[1],
            ),
          )
          .toList(),
    );
  }
}

@JsonSerializable()
class RouteItemModel {
  final RouteGeometryModel geometry;

  const RouteItemModel({required this.geometry});

  factory RouteItemModel.fromJson(Map<String, dynamic> json) =>
      _$RouteItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteItemModelToJson(this);
}

@JsonSerializable()
class RouteGeometryModel {
  final List<List<double>> coordinates;

  const RouteGeometryModel({required this.coordinates});

  factory RouteGeometryModel.fromJson(Map<String, dynamic> json) =>
      _$RouteGeometryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteGeometryModelToJson(this);
}
