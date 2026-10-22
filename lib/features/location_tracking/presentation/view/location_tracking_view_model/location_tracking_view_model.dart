import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/check_and_request_location_permission_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/is_location_service_enabled_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_reporting_use_case.dart';
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
    this._locationReportingUseCase,
    this._checkAndRequestPermissionUseCase,
    this._isLocationServiceEnabledUseCase,
    this._openAppSettingsUseCase,
    this._openLocationSettingsUseCase,
  ) : super(const LocationTrackingState());

  final LocationTrackingUseCase _locationTrackingUseCase;
  final LocationReportingUseCase _locationReportingUseCase;
  final CheckAndRequestLocationPermissionUseCase
  _checkAndRequestPermissionUseCase;
  final IsLocationServiceEnabledUseCase _isLocationServiceEnabledUseCase;
  final OpenAppSettingsUseCase _openAppSettingsUseCase;
  final OpenLocationSettingsUseCase _openLocationSettingsUseCase;

  StreamSubscription<LocationEntity>? _locationSubscription;
  bool _isStarting = false;

  Future<void> doEvent(LocationTrackingEvent event) async {
    switch (event) {
      case LocationTrackingStarted():
        await _startTracking();

      case LocationTrackingStopped():
        await _stopTracking();

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
      // 1. Check whether GPS is enabled.
      final serviceResponse = await _isLocationServiceEnabledUseCase();

      if (serviceResponse is ErrorResponse<bool>) {
        emit(state.copyWith(error: LocationTrackingError.serviceCheckFailed));
        return;
      }

      final isServiceEnabled = (serviceResponse as SuccessResponse<bool>).data;

      if (isServiceEnabled != true) {
        emit(state.copyWith(shouldShowLocationSettingsDialog: true));
        return;
      }

      // 2. Check/request location permission.
      final permissionResponse = await _checkAndRequestPermissionUseCase();

      if (permissionResponse is ErrorResponse<LocationPermission>) {
        emit(
          state.copyWith(error: LocationTrackingError.permissionCheckFailed),
        );
        return;
      }

      final permission =
          (permissionResponse as SuccessResponse<LocationPermission>).data;

      if (permission == null) {
        emit(
          state.copyWith(error: LocationTrackingError.permissionCheckFailed),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(shouldShowPermissionDialog: true));
        return;
      }

      if (permission == LocationPermission.denied) {
        emit(state.copyWith(error: LocationTrackingError.permissionDenied));
        return;
      }

      // 3. Start listening to location updates.
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

        unawaited(_reportLocation(location));
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

  Future<void> _reportLocation(LocationEntity location) async {
    final response = await _locationReportingUseCase(location);

    if (isClosed) return;

    if (response is ErrorResponse<LocationReportEntity>) {
      emit(state.copyWith(error: LocationTrackingError.reportFailed));
    }
  }

  Future<void> _openAppSettings() async {
    emit(state.copyWith(shouldShowPermissionDialog: false));

    final response = await _openAppSettingsUseCase();

    if (isClosed) return;

    if (response is ErrorResponse<bool>) {
      emit(state.copyWith(error: LocationTrackingError.openSettingsFailed));
    }
  }

  Future<void> _openLocationSettings() async {
    emit(state.copyWith(shouldShowLocationSettingsDialog: false));

    final response = await _openLocationSettingsUseCase();

    if (isClosed) return;

    if (response is ErrorResponse<bool>) {
      emit(state.copyWith(error: LocationTrackingError.openSettingsFailed));
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
    await super.close();
  }
}
