import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/order/core/order_status_progress.dart';

class OrderProgressBar extends StatelessWidget {
  final int completed;

  const OrderProgressBar({super.key, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < orderProgressSegmentCount; index++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 4,
                right: index == orderProgressSegmentCount - 1 ? 0 : 4,
              ),
              child: _ProgressSegment(filled: index < completed),
            ),
          ),
      ],
    );
  }
}

class _ProgressSegment extends StatelessWidget {
  final bool filled;

  const _ProgressSegment({required this.filled});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 5,
      decoration: BoxDecoration(
        color: filled ? context.colors.green : const Color(0xFFE4E4E4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
