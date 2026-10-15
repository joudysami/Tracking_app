import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/router/app_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/page/success_apply_page.dart';

class FakeApplyViewModel extends Cubit<ApplyState> implements ApplyViewModel {
  final List<ApplyEvent> dispatchedEvents = [];

  FakeApplyViewModel([ApplyState initialState = const ApplyState()])
    : super(initialState);

  @override
  Future<void> doEvent(ApplyEvent event) async {
    dispatchedEvents.add(event);
  }

  void emitState(ApplyState newState) {
    emit(newState);
  }
}

void main() {
  late FakeApplyViewModel fakeViewModel;

  const tVehicleTypeCar = VehicleTypeEntity(id: '1', name: 'Car');
  const tVehicleTypeVan = VehicleTypeEntity(id: '2', name: 'Van');

  const tApplyResult = ApplyResultEntity(
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '01012345678',
    gender: 'male',
    notificationStatus: 'active',
  );

  setUp(() {
    fakeViewModel = FakeApplyViewModel();
    if (getIt.isRegistered<ApplyViewModel>()) {
      getIt.unregister<ApplyViewModel>();
    }
    getIt.registerFactory<ApplyViewModel>(() => fakeViewModel);
  });

  tearDown(() {
    if (getIt.isRegistered<ApplyViewModel>()) {
      getIt.unregister<ApplyViewModel>();
    }
  });

  Widget buildTestWidget({
    String? initialLocation,
    ApplyViewModel? viewModelOverride,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        if (viewModelOverride != null) {
          return MaterialApp(
            theme: AppTheme(lightThemeColors).themeData,
            home: BlocProvider<ApplyViewModel>.value(
              value: viewModelOverride,
              child: const ApplyPage(),
            ),
          );
        }
        return MaterialApp.router(
          theme: AppTheme(lightThemeColors).themeData,
          routerConfig: AppRouter.createRouter(
            initialLocation: initialLocation ?? AppRoutes.apply,
          ),
        );
      },
    );
  }

  testWidgets(
    'Verify ApplyPage shows form fields, headers, and submit button',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(ApplyPage), findsOneWidget);
      expect(find.text(LocaleKeys.applyTitle.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.applyWelcome.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.applySubtitle.tr()), findsOneWidget);

      expect(find.byType(AppTextField), findsWidgets);
      expect(find.byType(InputDecorator), findsWidgets);
      expect(find.byType(Radio<Gender>), findsNWidgets(2));
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text(LocaleKeys.commonContinue.tr()), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'Verify loading state displays progress indicator on Continue button',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));

      fakeViewModel = FakeApplyViewModel(
        const ApplyState(applyState: BaseState(isLoading: true)),
      );
      getIt.unregister<ApplyViewModel>();
      getIt.registerFactory<ApplyViewModel>(() => fakeViewModel);

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final buttonFinder = find.byType(AppButton);
      expect(buttonFinder, findsOneWidget);
      expect(
        find.descendant(
          of: buttonFinder,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );

      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets('Verify error state displays SnackBar with the error message', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    fakeViewModel.emitState(
      fakeViewModel.state.copyWith(
        applyState: const BaseState(errorMessage: 'Invalid phone number'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Invalid phone number'), findsOneWidget);

    ScaffoldMessenger.of(
      tester.element(find.byType(ApplyPage)),
    ).hideCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify vehicle type dropdown displays types when populated', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));

    fakeViewModel = FakeApplyViewModel(
      const ApplyState(
        vehicleTypesState: BaseState(data: [tVehicleTypeCar, tVehicleTypeVan]),
      ),
    );
    getIt.unregister<ApplyViewModel>();
    getIt.registerFactory<ApplyViewModel>(() => fakeViewModel);

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    final dropdownFinder = find.byType(
      DropdownButtonFormField<VehicleTypeEntity>,
    );
    expect(dropdownFinder, findsOneWidget);

    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    expect(find.text('Car').last, findsOneWidget);
    expect(find.text('Van').last, findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify typing in fields sends events to ViewModel', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    final textFields = find.byType(AppTextField);

    // First Name
    await tester.enterText(textFields.at(0), 'John');
    expect(
      fakeViewModel.dispatchedEvents.any(
        (e) => e is FirstNameChanged && e.value == 'John',
      ),
      isTrue,
    );

    // Last Name
    await tester.enterText(textFields.at(1), 'Doe');
    expect(
      fakeViewModel.dispatchedEvents.any(
        (e) => e is LastNameChanged && e.value == 'Doe',
      ),
      isTrue,
    );

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify tapping Continue with valid form sends ApplyRequested', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1400));

    fakeViewModel = FakeApplyViewModel(
      const ApplyState(
        licenseImage: 'dummy_license.png',
        idImage: 'dummy_id.png',
        password: 'Password123',
        selectedVehicleType: tVehicleTypeCar,
        gender: Gender.male,
      ),
    );
    getIt.unregister<ApplyViewModel>();
    getIt.registerFactory<ApplyViewModel>(() => fakeViewModel);

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    // Fill valid values into each field:
    // 0: First legal name
    // 1: Second legal name
    // 2: Vehicle plate number (inside ApplyVehicleSection)
    // 3: Vehicle license (read-only file field)
    // 4: Email
    // 5: Phone
    // 6: National ID
    // 7: ID image (read-only file field)
    // 8: Password
    // 9: Confirm password
    final textFields = find.byType(AppTextField);

    await tester.enterText(textFields.at(0), 'John');
    await tester.enterText(textFields.at(1), 'Doe');
    await tester.enterText(textFields.at(2), '123ABC');
    await tester.enterText(textFields.at(4), 'john@example.com');
    await tester.enterText(textFields.at(5), '01012345678');
    await tester.enterText(textFields.at(6), '12345678901234');
    await tester.enterText(textFields.at(8), 'Password123');
    await tester.enterText(textFields.at(9), 'Password123');

    final continueButton = find.text(LocaleKeys.commonContinue.tr());
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pump();

    expect(
      fakeViewModel.dispatchedEvents.any((e) => e is ApplyRequested),
      isTrue,
    );

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Verify navigation to SuccessApplyPage on apply success', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.byType(ApplyPage), findsOneWidget);

    fakeViewModel.emitState(
      fakeViewModel.state.copyWith(
        applyState: const BaseState(data: tApplyResult),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SuccessApplyPage), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
