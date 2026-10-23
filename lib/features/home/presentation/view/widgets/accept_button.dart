
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';

class AcceptButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const AcceptButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
         padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                LocaleKeys.homeAccept.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
