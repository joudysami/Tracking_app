import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';


class LoginState extends Equatable {
  @override
  List<Object?> get props => [loginState];

  final BaseState<LoginEntity> loginState;

  const LoginState({this.loginState = const BaseState()});

  LoginState copyWith({BaseState<LoginEntity>? loginState}) {
    return LoginState(loginState: loginState ?? this.loginState);
  }
}