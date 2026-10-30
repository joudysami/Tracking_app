import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view/widgets/edit_profile_photo.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_nav_Widgets.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditProfileEffectListener(child: EditProfileScaffold());
  }
}

class EditProfileScaffold extends StatelessWidget {
  const EditProfileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(title: LocaleKeys.profileEditTitle.tr()),
      body: const EditProfileStateView(),
    );
  }
}

class EditProfileStateView extends StatelessWidget {
  const EditProfileStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.select(
      (EditProfileViewModel vm) => vm.state.profile,
    );
    if (profile.isLoading && profile.data == null) {
      return const ProfileLoading();
    }
    if (profile.data == null) return EditProfileLoadError(profile.errorMessage);
    return const EditProfileForm();
  }
}

class EditProfileLoadError extends StatelessWidget {
  const EditProfileLoadError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ProfileErrorView(message: message, onRetry: () => _retry(context));
  }
}

void _retry(BuildContext context) {
  context.read<EditProfileViewModel>().doEvent(const EditProfileStarted());
}

class EditProfileEffectListener extends StatefulWidget {
  const EditProfileEffectListener({required this.child, super.key});

  final Widget child;

  @override
  State<EditProfileEffectListener> createState() =>
      _EditProfileEffectListenerState();
}

class _EditProfileEffectListenerState extends State<EditProfileEffectListener> {
  StreamSubscription<EditProfileUiEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<EditProfileViewModel>().uiEvents.listen(
      _onEvent,
    );
  }

  void _onEvent(EditProfileUiEvent event) {
    if (!mounted) return;
    switch (event) {
      case ShowEditProfileError(:final message):
        _snack(message);
      case EditProfileSaved():
        context.pop(true);
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
