import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class LocationReportingUseCase {
  LocationReportingUseCase(this._locationRepo);

  final LocationRepo _locationRepo;

  Future<BaseResponse<LocationReportEntity>?> call(LocationEntity location) {
    return _locationRepo.reportLocation(location);
  }
}
