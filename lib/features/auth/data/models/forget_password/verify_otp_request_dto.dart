import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request_dto.g.dart';

@JsonSerializable()
class VerifyOtpRequestDto {
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "otp")
  final String? otp;

  VerifyOtpRequestDto ({
    this.email,
    this.otp,
  });

  factory VerifyOtpRequestDto.fromJson(Map<String, dynamic> json) {
    return _$VerifyOtpRequestDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VerifyOtpRequestDtoToJson(this);
  }
}


