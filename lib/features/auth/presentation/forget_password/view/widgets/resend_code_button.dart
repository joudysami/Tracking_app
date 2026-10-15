import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_color.dart';

import '../../../../../../core/localization/local_key.dart';

class ResendCodeButton extends StatefulWidget {
  const ResendCodeButton({
    super.key,
    required this.onResend,
    this.enabled = true,
    this.cooldownSeconds = 30,
  });

  final VoidCallback onResend;
  final bool enabled;
  final int cooldownSeconds;

  @override
  State<ResendCodeButton> createState() => _ResendCodeButtonState();
}

class _ResendCodeButtonState extends State<ResendCodeButton> {
  Timer? _timer;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.cooldownSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _remaining = _remaining <= 1 ? 0 : _remaining - 1);
      if (_remaining == 0) timer.cancel();
    });
  }

  void _onTap() {
    widget.onResend();
    setState(() => _remaining = widget.cooldownSeconds);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canTap = _remaining == 0 && widget.enabled;

    final label = _remaining == 0
        ? LocaleKeys.authResendCode.tr()
        : LocaleKeys.authResendIn.tr(namedArgs: {'seconds': '$_remaining'});

    return TextButton(
      onPressed: canTap ? _onTap : null,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: context.colors.pink,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}