import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/route_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class GetRouteUseCase {
  GetRouteUseCase(this._locationRepo);

  final LocationRepo _locationRepo;

  Future<BaseResponse<RouteEntity>> call({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return _locationRepo.getRoute(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );
  }
}
