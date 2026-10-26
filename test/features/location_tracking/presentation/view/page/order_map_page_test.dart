import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/router/app_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/features/location_tracking/data/models/map_party_model.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_error.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_event.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_state.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/page/order_map_page.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/map_party_card.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/map_pill.dart';

class FakeLocationTrackingViewModel extends Cubit<LocationTrackingState>
    implements LocationTrackingViewModel {
  final List<LocationTrackingEvent> dispatchedEvents = [];

  FakeLocationTrackingViewModel([
    LocationTrackingState initialState = const LocationTrackingState(),
  ]) : super(initialState);

  @override
  Future<void> doEvent(LocationTrackingEvent event) async {
    dispatchedEvents.add(event);
  }

  void emitState(LocationTrackingState newState) {
    emit(newState);
  }
}

void main() {
  late FakeLocationTrackingViewModel fakeViewModel;

  setUp(() {
    fakeViewModel = FakeLocationTrackingViewModel();
    if (getIt.isRegistered<LocationTrackingViewModel>()) {
      getIt.unregister<LocationTrackingViewModel>();
    }
    getIt.registerFactory<LocationTrackingViewModel>(() => fakeViewModel);
  });

  tearDown(() {
    if (getIt.isRegistered<LocationTrackingViewModel>()) {
      getIt.unregister<LocationTrackingViewModel>();
    }
  });

  Widget buildTestWidget({
    String? initialLocation,
    LocationTrackingViewModel? viewModelOverride,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      fontSizeResolver: (fontSize, instance) => 4.0,
      builder: (context, child) {
        if (viewModelOverride != null) {
          return MaterialApp(
            theme: AppTheme(lightThemeColors).themeData,
            home: BlocProvider<LocationTrackingViewModel>.value(
              value: viewModelOverride,
              child: OrderMapPage(
                order: orderMapMock,
                stage: OrderMapStage.pickup,
              ),
            ),
          );
        }
        return MaterialApp.router(
          theme: AppTheme(lightThemeColors).themeData,
          routerConfig: AppRouter.createRouter(
            initialLocation: initialLocation ?? AppRoutes.orderMap,
          ),
        );
      },
    );
  }

  testWidgets(
    'Verify OrderMapPage shows map, route, party cards, and dispatches LocationTrackingStarted',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(OrderMapPage), findsOneWidget);
      expect(find.byType(FlutterMap), findsOneWidget);
      expect(find.byType(MapPill), findsWidgets);
      expect(find.byType(MapPartyCard), findsNWidgets(2));
      expect(find.text(LocaleKeys.orderMapYourLocation.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.orderMapPickupAddress.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.orderMapUserAddress.tr()), findsOneWidget);
      expect(find.text(orderMapMock.store.name), findsWidgets);
      expect(find.text(orderMapMock.user.name), findsOneWidget);
      expect(
        fakeViewModel.dispatchedEvents.any((e) => e is LocationTrackingStarted),
        isTrue,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify permission dialog shows on shouldShowPermissionDialog and handles Cancel action',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      fakeViewModel.emitState(
        const LocationTrackingState(shouldShowPermissionDialog: true),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(LocaleKeys.locationPermissionDialogTitle.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.locationPermissionDialogMessage.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.cancel.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.locationOpenSettings.tr()), findsOneWidget);

      await tester.tap(find.text(LocaleKeys.cancel.tr()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        fakeViewModel.dispatchedEvents.any((e) => e is LocationPermissionDialogDismissed),
        isTrue,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify permission dialog Settings action dispatches OpenAppSettingsRequested',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      fakeViewModel.emitState(
        const LocationTrackingState(shouldShowPermissionDialog: true),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text(LocaleKeys.locationOpenSettings.tr()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        fakeViewModel.dispatchedEvents.any((e) => e is OpenAppSettingsRequested),
        isTrue,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify location settings dialog shows on shouldShowLocationSettingsDialog and handles Cancel',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      fakeViewModel.emitState(
        const LocationTrackingState(shouldShowLocationSettingsDialog: true),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(LocaleKeys.locationServiceDisabledTitle.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.locationServiceDisabledMessage.tr()), findsOneWidget);

      await tester.tap(find.text(LocaleKeys.cancel.tr()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        fakeViewModel.dispatchedEvents.any((e) => e is LocationSettingsDialogDismissed),
        isTrue,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify location settings dialog Settings button dispatches OpenLocationSettingsRequested',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      fakeViewModel.emitState(
        const LocationTrackingState(shouldShowLocationSettingsDialog: true),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text(LocaleKeys.locationOpenSettings.tr()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        fakeViewModel.dispatchedEvents.any((e) => e is OpenLocationSettingsRequested),
        isTrue,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify error state displays SnackBar with corresponding message',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      fakeViewModel.emitState(
        const LocationTrackingState(error: LocationTrackingError.permissionDenied),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(LocaleKeys.locationPermissionDenied.tr()), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify driver position updates when currentLocation changes',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      fakeViewModel.emitState(
        LocationTrackingState(
          isTracking: true,
          currentLocation: LocationEntity(
            lat: 30.0500,
            lng: 31.2500,
            recordedAt: DateTime.utc(2026, 10, 23, 12, 0, 0),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FlutterMap), findsOneWidget);
      expect(find.text(LocaleKeys.orderMapYourLocation.tr()), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify back button is displayed',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back_ios_new);
      expect(backButton, findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    },
  );
}
