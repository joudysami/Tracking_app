import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/check_and_request_location_permission_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/is_location_service_enabled_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_reporting_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_tracking_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/open_app_settings_use_case.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/open_location_settings_use_case.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_error.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_event.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_state.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart';

import 'location_tracking_view_model_test.mocks.dart';

@GenerateMocks([
  LocationTrackingUseCase,
  LocationReportingUseCase,
  CheckAndRequestLocationPermissionUseCase,
  IsLocationServiceEnabledUseCase,
  OpenAppSettingsUseCase,
  OpenLocationSettingsUseCase,
])
void main() {
  provideDummy<BaseResponse<bool>>(const SuccessResponse<bool>(true));
  provideDummy<BaseResponse<LocationPermission>>(
    const SuccessResponse<LocationPermission>(LocationPermission.whileInUse),
  );
  provideDummy<BaseResponse<LocationReportEntity>?>(null);

  late MockLocationTrackingUseCase mockLocationTrackingUseCase;
  late MockLocationReportingUseCase mockLocationReportingUseCase;
  late MockCheckAndRequestLocationPermissionUseCase mockCheckAndRequestPermissionUseCase;
  late MockIsLocationServiceEnabledUseCase mockIsLocationServiceEnabledUseCase;
  late MockOpenAppSettingsUseCase mockOpenAppSettingsUseCase;
  late MockOpenLocationSettingsUseCase mockOpenLocationSettingsUseCase;
  late LocationTrackingViewModel viewModel;
  late StreamController<LocationEntity> locationStreamController;

  final tLocation = LocationEntity(
    lat: 30.0444,
    lng: 31.2357,
    recordedAt: DateTime.utc(2026, 10, 23, 12, 0, 0),
  );

  setUp(() {
    mockLocationTrackingUseCase = MockLocationTrackingUseCase();
    mockLocationReportingUseCase = MockLocationReportingUseCase();
    mockCheckAndRequestPermissionUseCase =
        MockCheckAndRequestLocationPermissionUseCase();
    mockIsLocationServiceEnabledUseCase =
        MockIsLocationServiceEnabledUseCase();
    mockOpenAppSettingsUseCase = MockOpenAppSettingsUseCase();
    mockOpenLocationSettingsUseCase = MockOpenLocationSettingsUseCase();
    locationStreamController = StreamController<LocationEntity>.broadcast();

    viewModel = LocationTrackingViewModel(
      mockLocationTrackingUseCase,
      mockLocationReportingUseCase,
      mockCheckAndRequestPermissionUseCase,
      mockIsLocationServiceEnabledUseCase,
      mockOpenAppSettingsUseCase,
      mockOpenLocationSettingsUseCase,
    );
  });

  tearDown(() {
    locationStreamController.close();
  });

  group('LocationTrackingViewModel - Initial State', () {
    test('initial state has expected default values', () {
      expect(viewModel.state, const LocationTrackingState());
      expect(viewModel.state.isTracking, false);
      expect(viewModel.state.shouldShowPermissionDialog, false);
      expect(viewModel.state.shouldShowLocationSettingsDialog, false);
      expect(viewModel.state.currentLocation, isNull);
      expect(viewModel.state.error, isNull);
    });
  });

  group('LocationTrackingViewModel - LocationTrackingStarted Event', () {
    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits serviceCheckFailed error when isLocationServiceEnabledUseCase returns ErrorResponse',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => ErrorResponse(appError: BadResponseError('Service check failed')),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(LocationTrackingStarted()),
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>().having(
          (s) => s.error,
          'error',
          LocationTrackingError.serviceCheckFailed,
        ),
      ],
      verify: (_) {
        verify(mockIsLocationServiceEnabledUseCase()).called(1);
        verifyZeroInteractions(mockCheckAndRequestPermissionUseCase);
        verifyZeroInteractions(mockLocationTrackingUseCase);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits shouldShowLocationSettingsDialog when location service is disabled',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(false),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(LocationTrackingStarted()),
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowLocationSettingsDialog,
          'shouldShowLocationSettingsDialog',
          true,
        ),
      ],
      verify: (_) {
        verify(mockIsLocationServiceEnabledUseCase()).called(1);
        verifyZeroInteractions(mockCheckAndRequestPermissionUseCase);
        verifyZeroInteractions(mockLocationTrackingUseCase);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits permissionCheckFailed error when checkAndRequestPermissionUseCase returns ErrorResponse',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        when(mockCheckAndRequestPermissionUseCase()).thenAnswer(
          (_) async => ErrorResponse(appError: BadResponseError('Permission query failed')),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(LocationTrackingStarted()),
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>().having(
          (s) => s.error,
          'error',
          LocationTrackingError.permissionCheckFailed,
        ),
      ],
      verify: (_) {
        verify(mockIsLocationServiceEnabledUseCase()).called(1);
        verify(mockCheckAndRequestPermissionUseCase()).called(1);
        verifyZeroInteractions(mockLocationTrackingUseCase);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits permissionCheckFailed error when permission data is null',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        when(mockCheckAndRequestPermissionUseCase()).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(null),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(LocationTrackingStarted()),
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>().having(
          (s) => s.error,
          'error',
          LocationTrackingError.permissionCheckFailed,
        ),
      ],
      verify: (_) {
        verify(mockIsLocationServiceEnabledUseCase()).called(1);
        verify(mockCheckAndRequestPermissionUseCase()).called(1);
        verifyZeroInteractions(mockLocationTrackingUseCase);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits shouldShowPermissionDialog when permission is deniedForever',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        when(mockCheckAndRequestPermissionUseCase()).thenAnswer(
          (_) async => const SuccessResponse(LocationPermission.deniedForever),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(LocationTrackingStarted()),
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowPermissionDialog,
          'shouldShowPermissionDialog',
          true,
        ),
      ],
      verify: (_) {
        verify(mockIsLocationServiceEnabledUseCase()).called(1);
        verify(mockCheckAndRequestPermissionUseCase()).called(1);
        verifyZeroInteractions(mockLocationTrackingUseCase);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits permissionDenied error when permission is denied',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        when(mockCheckAndRequestPermissionUseCase()).thenAnswer(
          (_) async => const SuccessResponse(LocationPermission.denied),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(LocationTrackingStarted()),
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>().having(
          (s) => s.error,
          'error',
          LocationTrackingError.permissionDenied,
        ),
      ],
      verify: (_) {
        verify(mockIsLocationServiceEnabledUseCase()).called(1);
        verify(mockCheckAndRequestPermissionUseCase()).called(1);
        verifyZeroInteractions(mockLocationTrackingUseCase);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'starts tracking and emits updated location when prerequisites are met',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        when(mockCheckAndRequestPermissionUseCase()).thenAnswer(
          (_) async => const SuccessResponse(LocationPermission.whileInUse),
        );
        when(mockLocationTrackingUseCase()).thenAnswer(
          (_) => locationStreamController.stream,
        );
        when(mockLocationReportingUseCase(any)).thenAnswer(
          (_) async => const SuccessResponse(null),
        );
        return viewModel;
      },
      act: (vm) async {
        await vm.doEvent(LocationTrackingStarted());
        locationStreamController.add(tLocation);
      },
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>()
            .having((s) => s.isTracking, 'isTracking', true)
            .having((s) => s.currentLocation, 'currentLocation', tLocation)
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (_) {
        verify(mockIsLocationServiceEnabledUseCase()).called(1);
        verify(mockCheckAndRequestPermissionUseCase()).called(1);
        verify(mockLocationTrackingUseCase()).called(1);
        verify(mockLocationReportingUseCase(tLocation)).called(1);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits reportFailed error when reporting location fails',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        when(mockCheckAndRequestPermissionUseCase()).thenAnswer(
          (_) async => const SuccessResponse(LocationPermission.whileInUse),
        );
        when(mockLocationTrackingUseCase()).thenAnswer(
          (_) => locationStreamController.stream,
        );
        when(mockLocationReportingUseCase(any)).thenAnswer(
          (_) async => ErrorResponse(appError: BadResponseError('Report failed')),
        );
        return viewModel;
      },
      act: (vm) async {
        await vm.doEvent(LocationTrackingStarted());
        locationStreamController.add(tLocation);
      },
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>()
            .having((s) => s.isTracking, 'isTracking', true)
            .having((s) => s.currentLocation, 'currentLocation', tLocation),
        isA<LocationTrackingState>()
            .having((s) => s.isTracking, 'isTracking', true)
            .having((s) => s.currentLocation, 'currentLocation', tLocation)
            .having((s) => s.error, 'error', LocationTrackingError.reportFailed),
      ],
      verify: (_) {
        verify(mockLocationReportingUseCase(tLocation)).called(1);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits locationStreamFailed error when tracking stream encounters error',
      build: () {
        when(mockIsLocationServiceEnabledUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        when(mockCheckAndRequestPermissionUseCase()).thenAnswer(
          (_) async => const SuccessResponse(LocationPermission.whileInUse),
        );
        when(mockLocationTrackingUseCase()).thenAnswer(
          (_) => Stream.error(Exception('Stream error')),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(LocationTrackingStarted()),
      expect: () => [
        isA<LocationTrackingState>()
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.shouldShowPermissionDialog, 'shouldShowPermissionDialog', false)
            .having((s) => s.shouldShowLocationSettingsDialog, 'shouldShowLocationSettingsDialog', false),
        isA<LocationTrackingState>()
            .having((s) => s.isTracking, 'isTracking', false)
            .having((s) => s.error, 'error', LocationTrackingError.locationStreamFailed),
      ],
      verify: (_) {
        verify(mockLocationTrackingUseCase()).called(1);
        verifyZeroInteractions(mockLocationReportingUseCase);
      },
    );
  });

  group('LocationTrackingViewModel - LocationTrackingStopped Event', () {
    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits isTracking false when LocationTrackingStopped is received',
      seed: () => const LocationTrackingState(isTracking: true),
      build: () => viewModel,
      act: (vm) => vm.doEvent(LocationTrackingStopped()),
      expect: () => [
        isA<LocationTrackingState>().having((s) => s.isTracking, 'isTracking', false),
      ],
    );
  });

  group('LocationTrackingViewModel - Permission Dialog Actions', () {
    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'resets shouldShowPermissionDialog when LocationPermissionDialogDismissed is received',
      seed: () => const LocationTrackingState(shouldShowPermissionDialog: true),
      build: () => viewModel,
      act: (vm) => vm.doEvent(LocationPermissionDialogDismissed()),
      expect: () => [
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowPermissionDialog,
          'shouldShowPermissionDialog',
          false,
        ),
      ],
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'closes permission dialog and calls openAppSettingsUseCase on OpenAppSettingsRequested',
      build: () {
        when(mockOpenAppSettingsUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        return viewModel;
      },
      seed: () => const LocationTrackingState(shouldShowPermissionDialog: true),
      act: (vm) => vm.doEvent(OpenAppSettingsRequested()),
      expect: () => [
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowPermissionDialog,
          'shouldShowPermissionDialog',
          false,
        ),
      ],
      verify: (_) {
        verify(mockOpenAppSettingsUseCase()).called(1);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits openSettingsFailed error when openAppSettingsUseCase returns ErrorResponse',
      build: () {
        when(mockOpenAppSettingsUseCase()).thenAnswer(
          (_) async => ErrorResponse(appError: BadResponseError('Failed to open settings')),
        );
        return viewModel;
      },
      seed: () => const LocationTrackingState(shouldShowPermissionDialog: true),
      act: (vm) => vm.doEvent(OpenAppSettingsRequested()),
      expect: () => [
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowPermissionDialog,
          'shouldShowPermissionDialog',
          false,
        ),
        isA<LocationTrackingState>().having(
          (s) => s.error,
          'error',
          LocationTrackingError.openSettingsFailed,
        ),
      ],
      verify: (_) {
        verify(mockOpenAppSettingsUseCase()).called(1);
      },
    );
  });

  group('LocationTrackingViewModel - Location Settings Dialog Actions', () {
    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'resets shouldShowLocationSettingsDialog when LocationSettingsDialogDismissed is received',
      seed: () => const LocationTrackingState(shouldShowLocationSettingsDialog: true),
      build: () => viewModel,
      act: (vm) => vm.doEvent(LocationSettingsDialogDismissed()),
      expect: () => [
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowLocationSettingsDialog,
          'shouldShowLocationSettingsDialog',
          false,
        ),
      ],
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'closes location settings dialog and calls openLocationSettingsUseCase on OpenLocationSettingsRequested',
      build: () {
        when(mockOpenLocationSettingsUseCase()).thenAnswer(
          (_) async => const SuccessResponse(true),
        );
        return viewModel;
      },
      seed: () => const LocationTrackingState(shouldShowLocationSettingsDialog: true),
      act: (vm) => vm.doEvent(OpenLocationSettingsRequested()),
      expect: () => [
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowLocationSettingsDialog,
          'shouldShowLocationSettingsDialog',
          false,
        ),
      ],
      verify: (_) {
        verify(mockOpenLocationSettingsUseCase()).called(1);
      },
    );

    blocTest<LocationTrackingViewModel, LocationTrackingState>(
      'emits openSettingsFailed error when openLocationSettingsUseCase returns ErrorResponse',
      build: () {
        when(mockOpenLocationSettingsUseCase()).thenAnswer(
          (_) async => ErrorResponse(appError: BadResponseError('Failed to open location settings')),
        );
        return viewModel;
      },
      seed: () => const LocationTrackingState(shouldShowLocationSettingsDialog: true),
      act: (vm) => vm.doEvent(OpenLocationSettingsRequested()),
      expect: () => [
        isA<LocationTrackingState>().having(
          (s) => s.shouldShowLocationSettingsDialog,
          'shouldShowLocationSettingsDialog',
          false,
        ),
        isA<LocationTrackingState>().having(
          (s) => s.error,
          'error',
          LocationTrackingError.openSettingsFailed,
        ),
      ],
      verify: (_) {
        verify(mockOpenLocationSettingsUseCase()).called(1);
      },
    );
  });
}
