import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view/widgets/change_password_fields.dart';
<<<<<<< HEAD
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
=======
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_state.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_view_model.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChangePasswordEffectListener(child: ChangePasswordScaffold());
  }
}

class ChangePasswordScaffold extends StatelessWidget {
  const ChangePasswordScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.profileResetPassword.tr())),
      body: const ChangePasswordForm(),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
>>>>>>> origin/dev
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

<<<<<<< HEAD
=======
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordViewModel, ChangePasswordState>(
      listenWhen: _invalidChanged,
      listener: (_, _) => _formKey.currentState?.validate(),
      child: ChangePasswordFields(
        formKey: _formKey,
        current: _current,
        next: _next,
        confirm: _confirm,
      ),
    );
  }
}

bool _invalidChanged(
  ChangePasswordState previous,
  ChangePasswordState current,
) {
  return previous.invalidCurrentPassword != current.invalidCurrentPassword;
}

class ChangePasswordEffectListener extends StatefulWidget {
  const ChangePasswordEffectListener({required this.child, super.key});

  final Widget child;

  @override
  State<ChangePasswordEffectListener> createState() =>
      _ChangePasswordEffectListenerState();
}

class _ChangePasswordEffectListenerState
    extends State<ChangePasswordEffectListener> {
  StreamSubscription<ChangePasswordUiEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ChangePasswordViewModel>();
    _subscription = viewModel.uiEvents.listen(_onEvent);
  }

>>>>>>> origin/dev
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
<<<<<<< HEAD
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
=======
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
>>>>>>> origin/dev
}
