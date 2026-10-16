import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepLayout extends StatelessWidget {
  const StepLayout({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final Widget description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge , textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            description,
            SizedBox(height: 32.h),
            child,
          ],
        ),
      ),
    );
  }
}