import 'package:equatable/equatable.dart';

class ForgetPasswordRequest extends Equatable {
  final String? email;
  const ForgetPasswordRequest({this.email});

  @override
  List<Object?> get props => [email];
}
