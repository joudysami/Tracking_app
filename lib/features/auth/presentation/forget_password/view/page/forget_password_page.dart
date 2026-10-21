import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import '../../view_model/forget_password_event.dart';
import '../../view_model/forget_password_state.dart';
import '../../view_model/forget_password_ui_event.dart';
import '../../view_model/forget_password_view_model.dart';
import '../widgets/email_step_view.dart';
import '../widgets/otp_step_view.dart';
import '../widgets/reset_password_step_view.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late final ForgetPasswordViewModel _viewModel;
  late final StreamSubscription<ForgetPasswordUiEvent> _uiSub;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ForgetPasswordViewModel>();
    _uiSub = _viewModel.uiEvents.listen(_handleUiEvent);
  }

  void _handleUiEvent(ForgetPasswordUiEvent event) {
    if (!mounted) return;
    switch (event) {
      case ShowErrorUiEvent(:final message):
        _showSnack(message);
      case OtpResentUiEvent():
        _showSnack(LocaleKeys.authCodeResent.tr());
      case NavigateToLoginUiEvent():
        context.go(AppRoutes.login);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  void dispose() {
    _uiSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
        buildWhen: (p, c) => p.step != c.step,
        builder: (context, state) {
          final isFirstStep = state.step == ForgetPasswordStep.email;

          return PopScope(
            canPop: isFirstStep,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _viewModel.onEvent(const GoBackEvent());
            },
            child: Scaffold(
              appBar: AppBar(
                title:  Text(LocaleKeys.authPassword.tr()),
                leading: BackButton(
                  onPressed: () {
                    if (!isFirstStep) {
                      _viewModel.onEvent(const GoBackEvent());
                    } else if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.login);
                    }
                  },
                ),
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: switch (state.step) {
                  ForgetPasswordStep.email =>
                  const EmailStepView(key: ValueKey('email')),
                  ForgetPasswordStep.otp =>
                  const OtpStepView(key: ValueKey('otp')),
                  ForgetPasswordStep.resetPassword =>
                  const ResetPasswordStepView(key: ValueKey('reset')),
                },
              ),
            ),
          );
        },
    );
  }
}