import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/get_vehicle_types_usecase.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/logout_session_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_event.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_state.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_event.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_view_model.dart';

import '../support/profile_fixtures.dart';
import 'auth_repo_stub.dart';

void main() {
  test('profile load stores the driver and logout ends the session', () async {
    final repo = ScriptedProfileRepo();
    final viewModel = _profileViewModel(repo);
    final events = <ProfileUiEvent>[];
    viewModel.uiEvents.listen(events.add);

    await viewModel.doEvent(const ProfileRequested());
    await viewModel.doEvent(const LogoutConfirmed());

    expect(viewModel.state.profile.data, sampleProfile);
    expect(viewModel.state.vehicle.data, sampleVehicle);
    expect(repo.logoutCalls, 1);
    expect(events, [isA<LoggedOut>()]);
    await viewModel.close();
  });

  test('profile load keeps the error message', () async {
    final repo = ScriptedProfileRepo()
      ..profile = ErrorResponse(appError: BadResponseError('missing'));
    final viewModel = _profileViewModel(repo);

    await viewModel.doEvent(const ProfileRequested());

    expect(viewModel.state.profile.errorMessage, 'missing');
    await viewModel.close();
  });

  blocTest<EditProfileViewModel, EditProfileState>(
    'seeds the form and saves a changed name',
    build: () => _editViewModel(ScriptedProfileRepo()),
    act: (viewModel) async {
      await viewModel.doEvent(const EditProfileStarted());
      await viewModel.doEvent(const FirstNameChanged('Johnny'));
      await viewModel.doEvent(const UpdateProfileRequested());
    },
    verify: (viewModel) {
      expect(viewModel.state.firstName, 'Johnny');
      expect(viewModel.state.submit.data?.fullName, 'John Doe');
    },
  );

  test('saving profile sends the fields the api accepts', () async {
    final repo = ScriptedProfileRepo();
    final viewModel = _editViewModel(repo);
    final events = <EditProfileUiEvent>[];
    viewModel.uiEvents.listen(events.add);

    await viewModel.doEvent(const EditProfileStarted());
    await viewModel.doEvent(const UpdateProfileRequested());

    expect(events, [isA<EditProfileSaved>()]);
    expect(repo.lastProfile?.firstName, 'John');
    expect(repo.lastProfile?.phoneNumber, sampleProfile.phoneNumber);
    await viewModel.close();
  });

  test('vehicle edit sends the vehicle type id', () async {
    final repo = ScriptedProfileRepo();
    final viewModel = _vehicleViewModel(repo);
    final events = <EditVehicleUiEvent>[];
    viewModel.uiEvents.listen(events.add);

    await viewModel.doEvent(const EditVehicleStarted());
    viewModel.doEvent(const VehicleNumberChanged('ABC123'));
    await viewModel.doEvent(const UpdateVehicleRequested());

    expect(repo.lastVehicle?.vehicleTypeId, 'type-1');
    expect(repo.lastVehicle?.vehicleNumber, 'ABC123');
    expect(events, [isA<VehicleSaved>()]);
    await viewModel.close();
  });

  test('password errors are shown from the backend', () async {
    final repo = ScriptedProfileRepo()
      ..password = ErrorResponse(
        appError: BadResponseError('Current password is incorrect'),
      );
    final viewModel = ChangePasswordViewModel(ChangePasswordUseCase(repo));
    final events = <ChangePasswordUiEvent>[];
    viewModel.uiEvents.listen(events.add);

    viewModel.doEvent(const CurrentPasswordChanged('wrong'));
    viewModel.doEvent(const NewPasswordChanged('NewPass12'));
    viewModel.doEvent(const ConfirmPasswordChanged('NewPass12'));
    await viewModel.doEvent(const ChangePasswordSubmitted());

    expect(events, [isA<ShowChangePasswordError>()]);
    expect(
      (events.single as ShowChangePasswordError).message,
      'Current password is incorrect',
    );
    expect(viewModel.state.isLoading, isFalse);
    await viewModel.close();
  });
}

ProfileViewModel _profileViewModel(ScriptedProfileRepo repo) {
  return ProfileViewModel(
    GetProfileUseCase(repo),
    GetVehicleInfoUseCase(repo),
    LogoutSessionUseCase(repo),
  );
}

EditProfileViewModel _editViewModel(ScriptedProfileRepo repo) {
  return EditProfileViewModel(
    GetProfileUseCase(repo),
    UpdateProfileUseCase(repo),
    StubImagePicker(null),
  );
}

EditVehicleViewModel _vehicleViewModel(ScriptedProfileRepo repo) {
  return EditVehicleViewModel(
    GetVehicleInfoUseCase(repo),
    UpdateVehicleInfoUseCase(repo),
    FixedVehicleTypes(
      const SuccessResponse([
        VehicleTypeEntity(id: 'type-1', name: 'Motorcycle'),
        VehicleTypeEntity(id: 'type-2', name: 'Car'),
      ]),
    ),
    StubImagePicker(null),
  );
}

class StubImagePicker extends ImagePickerService {
  StubImagePicker(this.file) : super(ImagePicker());

  final XFile? file;

  @override
  Future<XFile?> pickImage() async => file;
}

class FixedVehicleTypes extends GetVehicleTypesUseCase {
  FixedVehicleTypes(this.response) : super(UnusedAuthRepo());

  final BaseResponse<List<VehicleTypeEntity>> response;

  @override
  Future<BaseResponse<List<VehicleTypeEntity>>> call() async => response;
}
