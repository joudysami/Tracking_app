import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/domain/entities/location_permission_status.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/route_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/check_and_request_location_permission_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/get_route_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/is_location_service_enabled_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_tracking_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/open_app_settings_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/open_location_settings_use_case.dart';

import 'location_tracking_error.dart';
import 'location_tracking_event.dart';
import 'location_tracking_state.dart';

@injectable
class LocationTrackingViewModel extends Cubit<LocationTrackingState> {
  LocationTrackingViewModel(
    this._locationTrackingUseCase,
    this._checkAndRequestPermissionUseCase,
    this._isLocationServiceEnabledUseCase,
    this._openAppSettingsUseCase,
    this._openLocationSettingsUseCase,
    this._getRouteUseCase,
  ) : super(const LocationTrackingState());

  final LocationTrackingUseCase _locationTrackingUseCase;
  final CheckAndRequestLocationPermissionUseCase
  _checkAndRequestPermissionUseCase;
  final IsLocationServiceEnabledUseCase _isLocationServiceEnabledUseCase;
  final OpenAppSettingsUseCase _openAppSettingsUseCase;
  final OpenLocationSettingsUseCase _openLocationSettingsUseCase;
  final GetRouteUseCase _getRouteUseCase;

  StreamSubscription<LocationEntity>? _locationSubscription;

  bool _isStarting = false;

  double? _destinationLatitude;
  double? _destinationLongitude;

  // Last driver location used for a successfully loaded route.
  double? _lastRouteStartLatitude;
  double? _lastRouteStartLongitude;

  static const double _routeRefreshDistanceMeters = 100;

  Future<void> doEvent(LocationTrackingEvent event) async {
    switch (event) {
      case LocationTrackingStarted():
        await _startTracking();

      case LocationTrackingStopped():
        await _stopTracking();

      case RouteRequested():
        _destinationLatitude = event.endLatitude;
        _destinationLongitude = event.endLongitude;

        await _loadRoute(
          startLatitude: event.startLatitude,
          startLongitude: event.startLongitude,
          endLatitude: event.endLatitude,
          endLongitude: event.endLongitude,
        );

      case LocationPermissionDialogDismissed():
        emit(state.copyWith(shouldShowPermissionDialog: false));

      case OpenAppSettingsRequested():
        await _openAppSettings();

      case LocationSettingsDialogDismissed():
        emit(state.copyWith(shouldShowLocationSettingsDialog: false));

      case OpenLocationSettingsRequested():
        await _openLocationSettings();
    }
  }

  Future<void> _loadRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    if (isClosed || state.isRouteLoading) return;

    // Refresh the route only after the driver moves far enough
    // from the origin used for the last successful route request.
    if (_lastRouteStartLatitude != null &&
        _lastRouteStartLongitude != null &&
        state.routePoints.isNotEmpty) {
      final distance = Geolocator.distanceBetween(
        _lastRouteStartLatitude!,
        _lastRouteStartLongitude!,
        startLatitude,
        startLongitude,
      );

      if (distance < _routeRefreshDistanceMeters) return;
    }

    emit(state.copyWith(isRouteLoading: true, error: null));

    try {
      final response = await _getRouteUseCase(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );

      if (isClosed) return;

      switch (response) {
        case ErrorResponse<RouteEntity>():
          emit(state.copyWith(error: LocationTrackingError.routeLoadFailed));

        case SuccessResponse<RouteEntity>(:final data):
          if (data == null || data.points.length < 2) {
            emit(state.copyWith(error: LocationTrackingError.routeLoadFailed));
            return;
          }

          // Save the origin only after successfully receiving a route.
          _lastRouteStartLatitude = startLatitude;
          _lastRouteStartLongitude = startLongitude;

          emit(state.copyWith(routePoints: data.points, error: null));
      }
    } finally {
      if (!isClosed && state.isRouteLoading) {
        emit(state.copyWith(isRouteLoading: false));
      }
    }
  }

  Future<void> _startTracking() async {
    if (_locationSubscription != null || _isStarting) return;

    _isStarting = true;

    emit(
      state.copyWith(
        error: null,
        shouldShowPermissionDialog: false,
        shouldShowLocationSettingsDialog: false,
      ),
    );

    try {
      final serviceResponse = await _isLocationServiceEnabledUseCase();

      switch (serviceResponse) {
        case ErrorResponse<bool>():
          emit(state.copyWith(error: LocationTrackingError.serviceCheckFailed));
          return;

        case SuccessResponse<bool>(:final data):
          if (data != true) {
            emit(state.copyWith(shouldShowLocationSettingsDialog: true));
            return;
          }
      }

      final permissionResponse = await _checkAndRequestPermissionUseCase();

      switch (permissionResponse) {
        case ErrorResponse<LocationPermissionStatus>():
          emit(
            state.copyWith(error: LocationTrackingError.permissionCheckFailed),
          );
          return;

        case SuccessResponse<LocationPermissionStatus>(:final data):
          if (data == null) {
            emit(
              state.copyWith(
                error: LocationTrackingError.permissionCheckFailed,
              ),
            );
            return;
          }

          if (data == LocationPermissionStatus.deniedForever) {
            emit(state.copyWith(shouldShowPermissionDialog: true));
            return;
          }

          if (data == LocationPermissionStatus.denied ||
              data == LocationPermissionStatus.unableToDetermine) {
            emit(state.copyWith(error: LocationTrackingError.permissionDenied));
            return;
          }
      }

      _listenToLocation();
    } finally {
      _isStarting = false;
    }
  }

  void _listenToLocation() {
    _locationSubscription = _locationTrackingUseCase().listen(
      (location) {
        if (isClosed) return;

        emit(
          state.copyWith(
            isTracking: true,
            currentLocation: location,
            error: null,
          ),
        );

        final destinationLatitude = _destinationLatitude;
        final destinationLongitude = _destinationLongitude;

        if (destinationLatitude != null && destinationLongitude != null) {
          unawaited(
            _loadRoute(
              startLatitude: location.lat,
              startLongitude: location.lng,
              endLatitude: destinationLatitude,
              endLongitude: destinationLongitude,
            ),
          );
        }
      },
      onError: (Object error) {
        _locationSubscription = null;

        if (isClosed) return;

        emit(
          state.copyWith(
            isTracking: false,
            error: LocationTrackingError.locationStreamFailed,
          ),
        );
      },
      onDone: () {
        _locationSubscription = null;

        if (isClosed) return;

        emit(state.copyWith(isTracking: false));
      },
    );
  }

  Future<void> _openAppSettings() async {
    emit(state.copyWith(shouldShowPermissionDialog: false));

    final response = await _openAppSettingsUseCase();

    if (isClosed) return;

    switch (response) {
      case ErrorResponse<bool>():
        emit(state.copyWith(error: LocationTrackingError.openSettingsFailed));

      case SuccessResponse<bool>():
        break;
    }
  }

  Future<void> _openLocationSettings() async {
    emit(state.copyWith(shouldShowLocationSettingsDialog: false));

    final response = await _openLocationSettingsUseCase();

    if (isClosed) return;

    switch (response) {
      case ErrorResponse<bool>():
        emit(state.copyWith(error: LocationTrackingError.openSettingsFailed));

      case SuccessResponse<bool>():
        break;
    }
  }

  Future<void> _stopTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    if (isClosed) return;

    emit(state.copyWith(isTracking: false));
  }

  @override
  Future<void> close() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    await super.close();
  }
}
