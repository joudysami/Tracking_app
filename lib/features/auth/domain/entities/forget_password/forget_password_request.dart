import 'package:equatable/equatable.dart';

class ForgetPasswordRequest extends Equatable {
  final String? email;
  const ForgetPasswordRequest({this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [email];
}
