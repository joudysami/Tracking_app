import 'package:equatable/equatable.dart';

class RouteEntity extends Equatable {
  final List<RoutePointEntity> points;

  const RouteEntity({required this.points});

  @override
  List<Object?> get props => [points];
}

class RoutePointEntity extends Equatable {
  final double longitude;
  final double latitude;

  const RoutePointEntity({required this.longitude, required this.latitude});

  @override
  List<Object?> get props => [longitude, latitude];
}
