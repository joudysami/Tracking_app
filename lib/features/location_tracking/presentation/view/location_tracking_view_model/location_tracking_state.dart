import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/route_entity.dart';

import 'location_tracking_error.dart';

part 'location_tracking_state.freezed.dart';

@freezed
abstract class LocationTrackingState with _$LocationTrackingState {
  const factory LocationTrackingState({
    @Default(false) bool isTracking,
    @Default(false) bool shouldShowPermissionDialog,
    @Default(false) bool shouldShowLocationSettingsDialog,
    @Default(false) bool isRouteLoading,
    @Default(<RoutePointEntity>[]) List<RoutePointEntity> routePoints,
    LocationEntity? currentLocation,
    LocationTrackingError? error,
  }) = _LocationTrackingState;
}
