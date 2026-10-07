import 'package:equatable/equatable.dart';

class VerifyOtpResponse extends Equatable{
  final String? otpToken;
  final int? expiresInMinutes;

  const VerifyOtpResponse ({
    this.otpToken,
    this.expiresInMinutes,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [otpToken, expiresInMinutes];
}


