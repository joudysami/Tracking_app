sealed class LocationTrackingEvent {}

class LocationTrackingStarted extends LocationTrackingEvent {}

class LocationTrackingStopped extends LocationTrackingEvent {}

class RouteRequested extends LocationTrackingEvent {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  RouteRequested({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });
}

class LocationPermissionDialogDismissed extends LocationTrackingEvent {}

class OpenAppSettingsRequested extends LocationTrackingEvent {}

class LocationSettingsDialogDismissed extends LocationTrackingEvent {}

class OpenLocationSettingsRequested extends LocationTrackingEvent {}
