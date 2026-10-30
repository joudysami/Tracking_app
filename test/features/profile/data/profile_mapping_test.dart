import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/profile/data/mapper/profile_gender_mapper.dart';
import 'package:tracking_app/features/profile/data/models/api_envelope.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_dto.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_dto.dart';
import 'package:tracking_app/features/profile/domain/profile_vehicle_type.dart';

void main() {
  test('maps profile gender names and legacy numbers', () {
    expect(genderFromApi('Male'), Gender.male);
    expect(genderFromApi('female'), Gender.female);
    expect(genderFromApi('0'), Gender.male);
    expect(genderFromApi('1'), Gender.female);
    expect(genderFromApi('other'), isNull);
    expect(genderToApi(Gender.male), '0');
    expect(genderToApi(Gender.female), '1');
  });

  test('normalizes vehicle type names sent by the profile api', () {
    expect(toProfileVehicleType(' bike '), profileMotorcycle);
    expect(toProfileVehicleType('Motorcycle'), profileMotorcycle);
    expect(toProfileVehicleType('Car'), profileCar);
    expect(toProfileVehicleType('Van'), 'Van');
  });

  test('reads success from success, isSuccess, and status', () {
    expect(readApiSuccess({'success': true}), isTrue);
    expect(readApiSuccess({'isSuccess': false}), isFalse);
    expect(readApiSuccess({'status': true, 'data': {}}), isTrue);
    expect(
      readApiSuccess({
        'data': {'id': '1'},
      }),
      isTrue,
    );
    expect(readApiMessage({'message': 'Nope'}), 'Nope');
  });

  test('maps a user profile payload onto the domain entity', () {
    final entity = UserProfileDto.fromJson(_profileJson).toEntity();

    expect(entity.userId, '1');
    expect(entity.fullName, 'John Doe');
    expect(entity.gender, Gender.male);
    expect(entity.email, 'john.doe@gmail.com');
  });

  test('joins first and last name when fullName is missing', () {
    final entity = UserProfileDto.fromJson({
      'firstName': 'John',
      'lastName': 'Doe',
    }).toEntity();

    expect(entity.fullName, 'John Doe');
  });

  test('reads the latest vehicle license file name', () {
    final entity = DriverProfileDto.fromJson({
      'vehicleTypeId': 'type-1',
      'vehicleTypeName': 'Motorcycle',
      'plateNumber': 'UP16DL0007',
      'licenseDocument': 'Storage/Drivers/a/Photo_12345678.png',
    }).toEntity();

    expect(entity.vehicleTypeId, 'type-1');
    expect(entity.licenseFileName, 'Photo_12345678.png');
    expect(entity.vehicleNumber, 'UP16DL0007');
    expect(entity.vehicleType, profileMotorcycle);
  });
}

const _profileJson = {
  'id': '1',
  'firstName': 'John',
  'lastName': 'Doe',
  'email': 'john.doe@gmail.com',
  'phoneNumber': '01211345678',
  'gender': 0,
  'profilePictureUrl': null,
};
