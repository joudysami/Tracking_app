import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';

class ChangePasswordRequestDto {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  const ChangePasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  factory ChangePasswordRequestDto.fromParams(ChangePasswordParams params) {
    return ChangePasswordRequestDto(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
      confirmNewPassword: params.confirmPassword,
    );
  }

  Map<String, dynamic> toJson() => _json(this);
}

Map<String, dynamic> _json(ChangePasswordRequestDto dto) {
  return {
    'currentPassword': dto.currentPassword,
    'newPassword': dto.newPassword,
    'confirmNewPassword': dto.confirmNewPassword,
  };
}
