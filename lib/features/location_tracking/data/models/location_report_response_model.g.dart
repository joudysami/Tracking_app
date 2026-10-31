// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_report_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationReportResponseModel _$LocationReportResponseModelFromJson(
  Map<String, dynamic> json,
) => LocationReportResponseModel(
  recordedAt: DateTime.parse(json['recordedAt'] as String),
  updatedOrderIds: (json['updatedOrderIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  broadcast: json['broadcast'] as bool,
);

Map<String, dynamic> _$LocationReportResponseModelToJson(
  LocationReportResponseModel instance,
) => <String, dynamic>{
  'recordedAt': instance.recordedAt.toIso8601String(),
  'updatedOrderIds': instance.updatedOrderIds,
  'broadcast': instance.broadcast,
};
