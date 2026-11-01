import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view/widgets/edit_vehicle_form.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_nav_Widgets.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

class EditVehiclePage extends StatelessWidget {
  const EditVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditVehicleEffectListener(child: EditVehicleScaffold());
  }
}

class EditVehicleScaffold extends StatelessWidget {
  const EditVehicleScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: LocaleKeys.profileEditTitle.tr(),
        showBell: true,
      ),
      body: const EditVehicleStateView(),
    );
  }
}

class EditVehicleStateView extends StatelessWidget {
  const EditVehicleStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((EditVehicleViewModel vm) => vm.state);
    if (state.isLoading && state.vehicle.data == null) {
      return const ProfileLoading();
    }
    if (state.vehicle.data == null) {
      return EditVehicleLoadError(state.vehicle.errorMessage);
    }
    return const EditVehicleForm();
  }
}

class EditVehicleLoadError extends StatelessWidget {
  const EditVehicleLoadError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ProfileErrorView(message: message, onRetry: () => _retry(context));
  }
}

void _retry(BuildContext context) {
  context.read<EditVehicleViewModel>().doEvent(const EditVehicleStarted());
}

class EditVehicleEffectListener extends StatefulWidget {
  const EditVehicleEffectListener({required this.child, super.key});

  final Widget child;

  @override
  State<EditVehicleEffectListener> createState() =>
      _EditVehicleEffectListenerState();
}

class _EditVehicleEffectListenerState extends State<EditVehicleEffectListener> {
  StreamSubscription<EditVehicleUiEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<EditVehicleViewModel>().uiEvents.listen(
      _onEvent,
    );
  }

  void _onEvent(EditVehicleUiEvent event) {
    if (!mounted) return;
    switch (event) {
      case ShowEditVehicleError(:final message):
        _snack(message);
      case VehicleSaved():
        context.pop();
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
