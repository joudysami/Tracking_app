import '../error/app_error.dart';

abstract class BaseUiEvent {
  const BaseUiEvent();
}

sealed class CommonUiEvent extends BaseUiEvent {
  const CommonUiEvent();
}

class NavigateEvent extends CommonUiEvent {
  final String route;
  final Object? arguments;

  const NavigateEvent(this.route, {this.arguments});
}

class NavigateReplacementEvent extends CommonUiEvent {
  final String route;
  final Object? arguments;

  const NavigateReplacementEvent(this.route, {this.arguments});
}

class PopEvent extends CommonUiEvent {
  final Object? result;

  const PopEvent([this.result]);
}

class ShowErrorSnackBarEvent extends CommonUiEvent {
  final AppError error;

  const ShowErrorSnackBarEvent(this.error);
}
