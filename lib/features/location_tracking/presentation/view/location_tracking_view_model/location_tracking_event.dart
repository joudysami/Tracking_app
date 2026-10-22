sealed class LocationTrackingEvent {}

class LocationTrackingStarted extends LocationTrackingEvent {}

class LocationTrackingStopped extends LocationTrackingEvent {}

class LocationPermissionDialogDismissed extends LocationTrackingEvent {}

class OpenAppSettingsRequested extends LocationTrackingEvent {}

class LocationSettingsDialogDismissed extends LocationTrackingEvent {}

class OpenLocationSettingsRequested extends LocationTrackingEvent {}
