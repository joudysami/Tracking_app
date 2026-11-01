import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../error/app_error.dart';
import 'base_ui_event.dart';

abstract class BaseViewModel<State, E extends BaseUiEvent>
    extends Cubit<State> {
  BaseViewModel(super.initialState);

  final StreamController<E> _uiEventStreamController =
      StreamController<E>.broadcast();

  Stream<E> get eventStream => _uiEventStreamController.stream;

  void emitEvent(E event) {
    if (_uiEventStreamController.isClosed) return;
    _uiEventStreamController.add(event);
  }

  void emitError(AppError error) {
    final BaseUiEvent event = ShowErrorSnackBarEvent(error);
    if (event is E) emitEvent(event);
  }

  @override
  Future<void> close() async {
    await _uiEventStreamController.close();
    return super.close();
  }
}
