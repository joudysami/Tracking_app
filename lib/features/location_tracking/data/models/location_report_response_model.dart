import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';

part 'location_report_response_model.g.dart';

/// Driver-location acknowledgement.
///
/// The backend answers with the standard `{status, code, message, data}`
/// envelope while the original mock returned the bare body, so both shapes
/// are accepted here and every field is optional. Reading a bare body out of
/// an envelope used to throw a `TypeError` on a successful (HTTP 200) call,
/// which surfaced as the generic "Something went wrong." message.
@JsonSerializable()
class LocationReportResponseModel {
  const LocationReportResponseModel({
    this.status,
    this.code,
    this.message,
    this.recordedAt,
    this.updatedOrderIds,
    this.broadcast,
  });

  factory LocationReportResponseModel.fromJson(Map<String, dynamic> json) {
    final body = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return _$LocationReportResponseModelFromJson({
      ...body,
      if (json['status'] != null) 'status': json['status'],
      if (json['code'] != null) 'code': json['code'],
      if (json['message'] != null) 'message': json['message'],
    });
  }

  final bool? status;
  final int? code;
  final String? message;
  final DateTime? recordedAt;
  final List<String>? updatedOrderIds;
  final bool? broadcast;

  Map<String, dynamic> toJson() => _$LocationReportResponseModelToJson(this);

  LocationReportEntity toDomain() {
    return LocationReportEntity(
      recordedAt: recordedAt ?? DateTime.now(),
      updatedOrderIds: updatedOrderIds ?? const [],
      broadcast: broadcast ?? false,
    );
  }
}
