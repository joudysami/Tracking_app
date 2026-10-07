import 'package:equatable/equatable.dart';

class VerifyOtpRequest extends Equatable {
  final String? email;
  final String? otp;

  const VerifyOtpRequest ({
    this.email,
    this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}


