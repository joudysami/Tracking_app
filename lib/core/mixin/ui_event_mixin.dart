import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../base/app_error_message.dart';
import '../base/base_ui_event.dart';
import '../base/base_view_model.dart';

mixin UiEventMixin<W extends StatefulWidget, S, E extends BaseUiEvent>
    on State<W> {
  BaseViewModel<S, E> get viewModel;

  StreamSubscription<E>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = viewModel.eventStream.listen(_handleUiEvent);
  }

  void _handleUiEvent(E event) {
    if (!mounted) return;
    if (event is CommonUiEvent) {
      handleCommonEvents(event);
    } else {
      handleCustomEvents(event);
    }
  }

  void handleCommonEvents(CommonUiEvent event) {
    switch (event) {
      case ShowErrorSnackBarEvent(:final error):
        final message = error.toUserMessage();
        if (message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      case NavigateEvent():
        context.push(event.route, extra: event.arguments);
      case NavigateReplacementEvent():
        context.go(event.route, extra: event.arguments);
      case PopEvent():
        if (context.canPop()) context.pop(event.result);
    }
  }

  void handleCustomEvents(E event) {}

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
