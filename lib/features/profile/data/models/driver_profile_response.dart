import 'package:tracking_app/features/profile/data/models/api_envelope.dart';
import 'package:tracking_app/features/profile/data/models/driver_profile_dto.dart';

class DriverProfileResponse {
  final bool success;
  final String? message;
  final DriverProfileDto? data;

  const DriverProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DriverProfileResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return DriverProfileResponse(
      success: readApiSuccess(json),
      message: readApiMessage(json),
      data: raw is Map<String, dynamic> ? DriverProfileDto.fromJson(raw) : null,
    );
  }
}
