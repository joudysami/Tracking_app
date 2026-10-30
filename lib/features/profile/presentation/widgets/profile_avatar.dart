import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/theme/app_color.dart';

class ProfileCircleAvatar extends StatelessWidget {
  const ProfileCircleAvatar({this.path, this.url, this.radius = 28, super.key});

  final String? path;
  final String? url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final image = profileImageOf(path, url);
    final diameter = radius.r * 2;
    final placeholder = Center(child: ProfilePersonIcon(radius: radius));
    return ClipOval(
      child: ColoredBox(
        color: context.colors.grey.shade300,
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: image == null
              ? placeholder
              : Image(
                  image: image,
                  width: diameter,
                  height: diameter,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => placeholder,
                ),
        ),
      ),
    );
  }
}

class ProfilePersonIcon extends StatelessWidget {
  const ProfilePersonIcon({required this.radius, super.key});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.person,
      size: radius.r,
      color: context.colors.grey.shade800,
    );
  }
}

ImageProvider<Object>? profileImageOf(String? path, String? url) {
  if (path != null && path.isNotEmpty) return FileImage(File(path));
  final resolved = ApiEndpoints.mediaUrl(url);
  if (resolved.isEmpty) return null;
  return NetworkImage(resolved);
}
