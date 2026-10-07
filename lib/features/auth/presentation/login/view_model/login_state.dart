import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';

class LoginState extends Equatable {
  const LoginState({
    this.submission = const BaseState(),
    this.credentialFailure = false,
  });

  final BaseState<AuthSession> submission;
  final bool credentialFailure;

  LoginState copyWith({
    BaseState<AuthSession>? submission,
    bool? credentialFailure,
  }) {
    return LoginState(
      submission: submission ?? this.submission,
      credentialFailure: credentialFailure ?? this.credentialFailure,
    );
  }

  @override
  List<Object?> get props => [submission, credentialFailure];
}
