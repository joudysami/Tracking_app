import 'package:json_annotation/json_annotation.dart';

part 'location_report_response_model.g.dart';

@JsonSerializable()
class LocationReportResponseModel {
  const LocationReportResponseModel({
    required this.recordedAt,
    required this.updatedOrderIds,
    required this.broadcast,
  });

  final DateTime recordedAt;
  final List<String> updatedOrderIds;
  final bool broadcast;

  factory LocationReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LocationReportResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationReportResponseModelToJson(this);
}
