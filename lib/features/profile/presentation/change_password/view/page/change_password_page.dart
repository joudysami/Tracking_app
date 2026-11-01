import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view/widgets/change_password_fields.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_view_model.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  StreamSubscription<ChangePasswordUiEvent>? _events;

  @override
  void initState() {
    super.initState();
    _events = context.read<ChangePasswordViewModel>().uiEvents.listen(_onEvent);
  }

  @override
  void dispose() {
    _events?.cancel();
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _onEvent(ChangePasswordUiEvent event) {
    if (!mounted) return;
    switch (event) {
      case ShowChangePasswordError(:final message):
        _snack(message);
      case PasswordChanged():
        context.go(AppRoutes.login);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.profileResetPassword.tr())),
      body: ChangePasswordFields(
        current: _current,
        next: _next,
        confirm: _confirm,
      ),
    );
  }
}
