import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/network/token_storage.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/models/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_dto.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/features/profile/data/models/operation_response.dart';
import 'package:tracking_app/features/profile/data/models/profile_form_requests.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_dto.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_response.dart';
import 'package:tracking_app/features/profile/data/repos/profile_repo_impl.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';

void main() {
  late FakeProfileRemote remote;
  late MemoryTokenStorage tokens;
  late ProfileRepoImpl repo;

  setUp(() {
    remote = FakeProfileRemote();
    tokens = MemoryTokenStorage();
    repo = ProfileRepoImpl(
      remote: remote,
      safeCall: SafeCall(),
      tokenStorage: tokens,
    );
  });

  test('returns the mapped profile when the envelope succeeds', () async {
    remote.profileResponse = _profile();

    final result = await repo.getProfile();

    expect(result, isA<SuccessResponse>());
    final profile = (result as SuccessResponse).data;
    expect(profile?.fullName, 'John Doe');
    expect(profile?.gender, Gender.male);
  });

  test('returns the envelope message when profile status is false', () async {
    remote.profileResponse = const UserProfileResponse(
      success: false,
      message: 'Profile was not found.',
      data: null,
    );

    final result = await repo.getProfile();

    expect(result, isA<ErrorResponse>());
    expect((result as ErrorResponse).errorMessage, 'Profile was not found.');
  });

  test('returns an error when the remote call throws', () async {
    remote.error = Exception('offline');

    final result = await repo.getProfile();

    expect(result, isA<ErrorResponse>());
  });

  test('keeps the session after a profile update', () async {
    remote.profileResponse = _profile();

    await repo.updateProfile(_profileParams());

    expect(tokens.clears, 0);
  });

  test('maps vehicle info including the license file name', () async {
    final result = await repo.getVehicleInfo();

    final vehicle = (result as SuccessResponse).data;
    expect(vehicle?.vehicleNumber, 'UP16DL0007');
    expect(vehicle?.licenseFileName, 'Photo_12345678.png');
  });

  test('clears tokens after a successful password change', () async {
    remote.operation = const OperationResponse(success: true, message: null);

    final result = await repo.changePassword(_passwordParams());

    expect(result, isA<SuccessResponse>());
    expect(tokens.clears, 1);
  });

  test('keeps tokens when the current password is rejected', () async {
    remote.operation = const OperationResponse(
      success: false,
      message: 'Current password is incorrect',
    );

    final result = await repo.changePassword(_passwordParams());

    expect(
      (result as ErrorResponse).errorMessage,
      'Current password is incorrect',
    );
    expect(tokens.clears, 0);
  });

  test(
    'revokes the refresh token and always clears the local session',
    () async {
      tokens.refresh = 'refresh-1';

      final result = await repo.logout();

      expect(result, isA<SuccessResponse>());
      expect(remote.loggedOutWith, 'refresh-1');
      expect(tokens.clears, 1);
    },
  );
}

UserProfileResponse _profile() {
  return UserProfileResponse(
    success: true,
    message: null,
    data: UserProfileDto.fromJson({
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@gmail.com',
      'phoneNumber': '01211345678',
      'gender': 'Male',
    }),
  );
}

UpdateProfileParams _profileParams() {
  return const UpdateProfileParams(
    firstName: 'John',
    lastName: 'Doe',
    phoneNumber: '01211345678',
    gender: Gender.male,
    photoPath: null,
  );
}

ChangePasswordParams _passwordParams() {
  return const ChangePasswordParams(
    currentPassword: 'OldPass12',
    newPassword: 'NewPass12',
    confirmPassword: 'NewPass12',
  );
}

class FakeProfileRemote implements ProfileRemoteDataSource {
  UserProfileResponse? profileResponse;
  OperationResponse? operation;
  Object? error;
  String? loggedOutWith;

  @override
  Future<UserProfileResponse> getProfile() => _value(profileResponse);

  @override
  Future<UserProfileResponse> updateProfile(UpdateProfileRequest request) {
    return _value(profileResponse);
  }

  @override
  Future<DriverProfileResponse> getVehicle() => _value(_licenseVehicle());

  @override
  Future<DriverProfileResponse> updateVehicle(UpdateVehicleRequest request) {
    return _value(_licenseVehicle());
  }

  @override
  Future<OperationResponse> changePassword(ChangePasswordRequestDto request) {
    return _value(operation);
  }

  @override
  Future<OperationResponse> logout(String refreshToken) {
    loggedOutWith = refreshToken;
    return _value(const OperationResponse(success: true, message: null));
  }

  Future<T> _value<T>(T? value) async {
    if (error != null) throw error!;
    return value as T;
  }
}

DriverProfileResponse _licenseVehicle() {
  return DriverProfileResponse(
    success: true,
    message: null,
    data: DriverProfileDto.fromJson({
      'vehicleTypeId': 'type-1',
      'vehicleTypeName': 'Motorcycle',
      'plateNumber': 'UP16DL0007',
      'licenseDocument': 'Storage/Drivers/a/Photo_12345678.png',
    }),
  );
}

class MemoryTokenStorage implements TokenStorage {
  String? refresh;
  int clears = 0;

  @override
  Future<void> clearTokens() async => clears++;

  @override
  Future<String?> getAccessToken() async => 'access';

  @override
  Future<String?> getRefreshToken() async => refresh;

  @override
  Future<void> saveAccessToken(String accessToken) async {}

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}
}
