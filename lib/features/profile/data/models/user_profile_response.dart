import 'package:tracking_app/features/profile/data/models/api_envelope.dart';
import 'package:tracking_app/features/profile/data/models/user_profile_dto.dart';

class UserProfileResponse {
  final bool success;
  final String? message;
  final UserProfileDto? data;

  const UserProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return UserProfileResponse(
      success: readApiSuccess(json),
      message: readApiMessage(json),
      data: raw is Map<String, dynamic> ? UserProfileDto.fromJson(raw) : null,
    );
  }
}
