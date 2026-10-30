import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/logout_session_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view/page/change_password_page.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view/page/edit_profile_page.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_state.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile/view/page/profile_page.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_event.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_state.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/logout_dialog.dart';

import '../support/profile_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    _mockPreferences();
    EasyLocalization.logger.enableBuildModes = [];
    await EasyLocalization.ensureInitialized();
    final raw = await rootBundle.loadString('assets/translations/en.json');
    _english = json.decode(raw) as Map<String, dynamic>;
  });

  testWidgets('profile screen shows the driver, vehicle, and logout', (
    tester,
  ) async {
    _useWideScreen(tester);
    final viewModel = _profile();
    await _show(tester, _app(viewModel: viewModel, child: const ProfilePage()));
    _expectProfile();
    await _cancelLogout(tester, viewModel);
    await _confirmLogout(tester, viewModel);
  });

  testWidgets('edit profile shows the loaded form and gender', (tester) async {
    _useWideScreen(tester);
    await _show(tester, _editApp());
    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text(LocaleKeys.profileChange.tr()), findsOneWidget);
    expect(find.byType(Radio<Gender>), findsNWidgets(2));
    expect(find.text(LocaleKeys.profileUpdate.tr()), findsOneWidget);
  });

  testWidgets('reset password shows the backend error', (tester) async {
    _useWideScreen(tester);
    final repo = ScriptedProfileRepo()
      ..password = ErrorResponse(
        appError: BadResponseError('Current password is incorrect'),
      );
    final viewModel = ChangePasswordViewModel(ChangePasswordUseCase(repo));
    addTearDown(viewModel.close);
    await _show(tester, _passwordApp(viewModel));

    await tester.enterText(find.byType(TextFormField).at(0), 'OldPass1');
    await tester.enterText(find.byType(TextFormField).at(1), 'NewPass12');
    await tester.enterText(find.byType(TextFormField).at(2), 'NewPass12');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Current password is incorrect'), findsOneWidget);
  });

  testWidgets('reset password update enables only for a valid form', (
    tester,
  ) async {
    _useWideScreen(tester);
    final viewModel = ChangePasswordViewModel(
      ChangePasswordUseCase(ScriptedProfileRepo()),
    );
    await _show(
      tester,
      _screen(
        BlocProvider.value(value: viewModel, child: const ChangePasswordPage()),
      ),
    );

    ElevatedButton update() =>
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(update().onPressed, isNull);

    await tester.enterText(find.byType(TextFormField).at(0), 'OldPass1');
    await tester.enterText(find.byType(TextFormField).at(1), 'NewPass12');
    await tester.enterText(find.byType(TextFormField).at(2), 'NewPass12');
    await tester.pumpAndSettle();
    expect(update().onPressed, isNotNull);

    await tester.enterText(find.byType(TextFormField).at(2), 'different');
    await tester.pumpAndSettle();
    expect(update().onPressed, isNull);
  });
}

class _FakeProfileViewModel extends ProfileViewModel {
  _FakeProfileViewModel(ProfileState state)
    : super(
        GetProfileUseCase(ScriptedProfileRepo()),
        GetVehicleInfoUseCase(ScriptedProfileRepo()),
        LogoutSessionUseCase(ScriptedProfileRepo()),
      ) {
    emit(state);
  }

  final events = <ProfileEvent>[];

  @override
  Future<void> doEvent(ProfileEvent event) async => events.add(event);
}

class _FakeEditProfileViewModel extends EditProfileViewModel {
  _FakeEditProfileViewModel(EditProfileState state)
    : super(
        GetProfileUseCase(ScriptedProfileRepo()),
        UpdateProfileUseCase(ScriptedProfileRepo()),
        _IdleImages(),
      ) {
    emit(state);
  }

  @override
  Future<void> doEvent(EditProfileEvent event) async {}
}

class _IdleImages extends ImagePickerService {
  _IdleImages() : super(ImagePicker());
}

Widget _app({required ProfileViewModel viewModel, required Widget child}) {
  return _screen(
    BlocProvider<ProfileViewModel>.value(value: viewModel, child: child),
  );
}

Widget _editApp() {
  return _screen(
    BlocProvider<EditProfileViewModel>.value(
      value: _editViewModel(),
      child: const EditProfilePage(),
    ),
  );
}

EditProfileViewModel _editViewModel() {
  return _FakeEditProfileViewModel(
    const EditProfileState(
      profile: BaseState(data: sampleProfile),
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@gmail.com',
      phone: '01211345678',
      gender: Gender.male,
    ),
  );
}

Widget _passwordApp(ChangePasswordViewModel viewModel) {
  return _screen(
    BlocProvider.value(value: viewModel, child: const ChangePasswordPage()),
  );
}

Widget _screen(Widget child) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('en'),
    assetLoader: const _MemoryLoader(),
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: AppTheme(lightThemeColors).themeData,
        home: child,
      ),
    ),
  );
}

late Map<String, dynamic> _english;

class _MemoryLoader extends AssetLoader {
  const _MemoryLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return _english;
  }
}

Future<void> _show(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(widget);
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void _mockPreferences() {
  const channel = MethodChannel('plugins.flutter.io/shared_preferences');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getAll') return <String, Object>{};
        return null;
      });
}

_FakeProfileViewModel _profile() {
  return _FakeProfileViewModel(
    const ProfileState(
      profile: BaseState(data: sampleProfile),
      vehicle: BaseState(data: sampleVehicle),
    ),
  );
}

void _useWideScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void _expectProfile() {
  expect(find.text('John Doe'), findsOneWidget);
  expect(find.text('john.doe@gmail.com'), findsOneWidget);
  expect(find.text('01211345678'), findsOneWidget);
  expect(find.text(LocaleKeys.profileBike.tr()), findsOneWidget);
  expect(find.text('UP16DL0007'), findsOneWidget);
  expect(find.text(LocaleKeys.profileLogoutAction.tr()), findsOneWidget);
  expect(find.text(LocaleKeys.navProfile.tr()), findsOneWidget);
  expect(find.textContaining('1.0.0'), findsOneWidget);
}

Future<void> _cancelLogout(
  WidgetTester tester,
  _FakeProfileViewModel viewModel,
) async {
  await tester.tap(find.text(LocaleKeys.profileLogoutAction.tr()));
  await tester.pumpAndSettle();
  expect(find.byType(LogoutDialog), findsOneWidget);
  await tester.tap(find.text(LocaleKeys.commonCancel.tr()));
  await tester.pumpAndSettle();
  expect(viewModel.events, isEmpty);
}

Future<void> _confirmLogout(
  WidgetTester tester,
  _FakeProfileViewModel viewModel,
) async {
  await tester.tap(find.text(LocaleKeys.profileLogoutAction.tr()));
  await tester.pumpAndSettle();
  await tester.tap(find.text(LocaleKeys.profileLogoutAction.tr()).last);
  await tester.pumpAndSettle();
  expect(viewModel.events, [isA<LogoutConfirmed>()]);
}
