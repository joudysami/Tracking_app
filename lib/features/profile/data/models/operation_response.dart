import 'package:tracking_app/features/profile/data/models/api_envelope.dart';

class OperationResponse {
  final bool success;
  final String? message;

  const OperationResponse({required this.success, required this.message});

  factory OperationResponse.fromJson(Map<String, dynamic> json) {
    return OperationResponse(
      success: readApiSuccess(json),
      message: readApiMessage(json),
    );
  }
}
