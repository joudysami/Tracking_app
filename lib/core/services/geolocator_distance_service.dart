import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/services/distance_service.dart';


@Injectable(as: DistanceService)
class GeolocatorDistanceService implements DistanceService {
  @override
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
