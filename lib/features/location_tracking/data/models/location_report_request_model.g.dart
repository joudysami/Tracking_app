// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_report_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationReportRequestModel _$LocationReportRequestModelFromJson(
  Map<String, dynamic> json,
) => LocationReportRequestModel(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  recordedAt: DateTime.parse(json['recordedAt'] as String),
);

Map<String, dynamic> _$LocationReportRequestModelToJson(
  LocationReportRequestModel instance,
) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
  'recordedAt': instance.recordedAt.toIso8601String(),
};
