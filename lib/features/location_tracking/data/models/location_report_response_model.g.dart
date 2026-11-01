// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_report_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationReportResponseModel _$LocationReportResponseModelFromJson(
  Map<String, dynamic> json,
) => LocationReportResponseModel(
  status: json['status'] as bool?,
  code: (json['code'] as num?)?.toInt(),
  message: json['message'] as String?,
  recordedAt: json['recordedAt'] == null
      ? null
      : DateTime.parse(json['recordedAt'] as String),
  updatedOrderIds: (json['updatedOrderIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  broadcast: json['broadcast'] as bool?,
);

Map<String, dynamic> _$LocationReportResponseModelToJson(
  LocationReportResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'code': instance.code,
  'message': instance.message,
  'recordedAt': instance.recordedAt?.toIso8601String(),
  'updatedOrderIds': instance.updatedOrderIds,
  'broadcast': instance.broadcast,
};
