import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/profile/presentation/profile/view/widgets/profile_summary.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_ui_event.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile/view_model/profile_event.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_chrome.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileEffectListener(child: ProfileScaffold());
  }
}

class ProfileScaffold extends StatelessWidget {
  const ProfileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: LocaleKeys.profileScreenTitle.tr(),
        showBell: true,
      ),
      body: const ProfileStateView(),
      bottomNavigationBar: const ProfileBottomNav(),
    );
  }
}

class ProfileStateView extends StatelessWidget {
  const ProfileStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.select((ProfileViewModel vm) => vm.state.profile);
    if (profile.isLoading && profile.data == null) {
      return const ProfileLoading();
    }
    if (profile.data == null) return ProfileLoadError(profile.errorMessage);
    return const ProfileContent();
  }
}

class ProfileLoadError extends StatelessWidget {
  const ProfileLoadError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ProfileErrorView(message: message, onRetry: () => _retry(context));
  }
}

void _retry(BuildContext context) {
  context.read<ProfileViewModel>().doEvent(const ProfileRequested());
}

class ProfileEffectListener extends StatefulWidget {
  const ProfileEffectListener({required this.child, super.key});

  final Widget child;

  @override
  State<ProfileEffectListener> createState() => _ProfileEffectListenerState();
}

class _ProfileEffectListenerState extends State<ProfileEffectListener> {
  StreamSubscription<ProfileUiEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<ProfileViewModel>().uiEvents.listen(_onEvent);
  }

  void _onEvent(ProfileUiEvent event) {
    if (!mounted) return;
    if (event is LoggedOut) context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
