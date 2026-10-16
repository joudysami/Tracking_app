import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

@JsonSerializable()
class ResetPasswordRequestDto {
  @JsonKey(name: "otpToken")
  final String? otpToken;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "confirmPassword")
  final String? confirmPassword;

  ResetPasswordRequestDto ({
    this.otpToken,
    this.password,
    this.confirmPassword,
  });

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) {
    return _$ResetPasswordRequestDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResetPasswordRequestDtoToJson(this);
  }
}


