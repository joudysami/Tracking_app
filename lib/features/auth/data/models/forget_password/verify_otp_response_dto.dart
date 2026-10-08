import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response_dto.g.dart';

@JsonSerializable()
class VerifyOtpResponseDto {
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "code")
  final int? code;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final VerifyOtpDataDto? data;
  @JsonKey(name: "pagination")
  final dynamic? pagination;
  @JsonKey(name: "errors")
  final dynamic? errors;

  VerifyOtpResponseDto ({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory VerifyOtpResponseDto.fromJson(Map<String, dynamic> json) {
    return _$VerifyOtpResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VerifyOtpResponseDtoToJson(this);
  }
}

@JsonSerializable()
class VerifyOtpDataDto {
  @JsonKey(name: "otpToken")
  final String? otpToken;
  @JsonKey(name: "expiresInMinutes")
  final int? expiresInMinutes;

  VerifyOtpDataDto ({
    this.otpToken,
    this.expiresInMinutes,
  });

  factory VerifyOtpDataDto.fromJson(Map<String, dynamic> json) {
    return _$VerifyOtpDataDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VerifyOtpDataDtoToJson(this);
  }
}


