
import 'package:json_annotation/json_annotation.dart';

part 'update_status_request.g.dart';

@JsonSerializable()
class UpdateStatusRequest {
  final String status;
  final String note;

  const UpdateStatusRequest({
    required this.status,
    required this.note,
  });

  factory UpdateStatusRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateStatusRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateStatusRequestToJson(this);
}
