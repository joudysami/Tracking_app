class RouteEntity {
  final List<RoutePointEntity> points;

  const RouteEntity({required this.points});
}

class RoutePointEntity {
  final double longitude;
  final double latitude;

  const RoutePointEntity({required this.longitude, required this.latitude});
}
