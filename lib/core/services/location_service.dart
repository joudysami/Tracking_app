import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/domain/entities/geo_point.dart';
import 'package:tracking_app/core/domain/entities/location_permission_status.dart';

@injectable
class LocationService {
  final GeolocatorPlatform geolocator;

  LocationService(this.geolocator);

  Future<bool> isLocationServiceEnabled() async {
    return geolocator.isLocationServiceEnabled();
  }

  LocationPermissionStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.whileInUse;
      case LocationPermission.always:
        return LocationPermissionStatus.always;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unableToDetermine;
    }
  }

  Future<LocationPermissionStatus> checkPermission() async {
    final permission = await geolocator.checkPermission();
    return _mapPermission(permission);
  }

  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await geolocator.requestPermission();
    return _mapPermission(permission);
  }

  Future<bool> openAppSettings() async {
    return geolocator.openAppSettings();
  }

  Future<bool> openLocationSettings() async {
    return geolocator.openLocationSettings();
  }

  Future<GeoPoint> getCurrentPosition() async {
    final position = await geolocator.getCurrentPosition();

    return GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }

  Stream<GeoPoint> getPositionStream() {
    return geolocator
        .getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 12,
          ),
        )
        .map(
          (position) => GeoPoint(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
  }
}
