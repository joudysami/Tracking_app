import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/profile/presentation/change_password/can_change_password.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_state.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/edit_profile_rules.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_state.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/edit_vehicle_rules.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_state.dart';

import '../support/profile_fixtures.dart';

void main() {
  test('update stays disabled until the profile form changes', () {
    final loaded = EditProfileState(
      profile: const BaseState(data: sampleProfile),
      firstName: sampleProfile.firstName,
      lastName: sampleProfile.lastName,
      email: sampleProfile.email,
      phone: sampleProfile.phoneNumber,
      gender: sampleProfile.gender,
    );

    expect(canUpdateProfile(loaded), isFalse);
    expect(canUpdateProfile(loaded.copyWith(firstName: 'Johnny')), isTrue);
    expect(canUpdateProfile(loaded.copyWith(gender: Gender.female)), isTrue);
  });

  test('vehicle update stays disabled until a field changes', () {
    const bike = VehicleTypeEntity(id: 'type-1', name: 'Motorcycle');
    final loaded = EditVehicleState(
      vehicle: const BaseState(data: sampleVehicle),
      types: const BaseState(data: [bike]),
      selectedType: bike,
      vehicleNumber: sampleVehicle.vehicleNumber,
      licenseName: sampleVehicle.licenseFileName,
    );

    expect(canUpdateVehicle(loaded), isFalse);
    expect(canUpdateVehicle(loaded.copyWith(vehicleNumber: 'CAR1')), isTrue);
  });

  test('password update needs eight characters and a matching confirm', () {
    const empty = ChangePasswordState();
    const mismatch = ChangePasswordState(
      currentPassword: 'OldPass1',
      newPassword: 'NewPass12',
      confirmPassword: 'OtherPass1',
    );
    const ready = ChangePasswordState(
      currentPassword: 'OldPass1',
      newPassword: 'NewPass12',
      confirmPassword: 'NewPass12',
    );

    expect(canChangePassword(empty), isFalse);
    expect(canChangePassword(mismatch), isFalse);
    expect(canChangePassword(ready), isTrue);
  });
}
