
import 'package:json_annotation/json_annotation.dart';

part 'location_report_request_model.g.dart';

@JsonSerializable()
class LocationReportRequestModel {
  const LocationReportRequestModel({
    required this.lat,
    required this.lng,
    required this.recordedAt,
  });

  final double lat;
  final double lng;
  final DateTime recordedAt;

  factory LocationReportRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LocationReportRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationReportRequestModelToJson(this);
}
