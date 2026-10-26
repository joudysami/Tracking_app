import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class OpenLocationSettingsUseCase {
  OpenLocationSettingsUseCase(this._locationRepo);

  final LocationRepo _locationRepo;

  Future<BaseResponse<bool>> call() {
    return _locationRepo.openLocationSettings();
  }
}
