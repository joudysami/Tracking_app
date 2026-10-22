import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class LocationTrackingUseCase {
  LocationTrackingUseCase(this._locationRepo);

  final LocationRepo _locationRepo;

  Stream<LocationEntity> call() {
    return _locationRepo.getPositionStream();
  }
}
