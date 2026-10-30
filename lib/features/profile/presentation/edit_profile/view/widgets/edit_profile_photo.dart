import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view/widgets/edit_profile_account.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view/widgets/edit_profile_fields.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: const [
        ProfilePhotoPicker(),
        ProfileSectionGap(height: 24),
        EditProfileFields(),
        ProfileSectionGap(height: 32),
        EditProfileUpdateButton(),
      ],
    );
  }
}

class EditProfileFields extends StatelessWidget {
  const EditProfileFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProfileNameFields(),
        ProfileSectionGap(),
        ProfileEmailField(),
        ProfileSectionGap(),
        ProfilePhoneField(),
        ProfileSectionGap(),
        ProfilePasswordField(),
        ProfileSectionGap(),
        ProfileGenderField(),
      ],
    );
  }
}

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final photo = context.select(_photo);
    return Center(
      child: ProfilePhotoButton(path: photo.$1, url: photo.$2),
    );
  }
}

class ProfilePhotoButton extends StatelessWidget {
  const ProfilePhotoButton({required this.path, required this.url, super.key});

  final String? path;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pick(context),
      child: ProfilePhotoFrame(path: path, url: url),
    );
  }
}

class ProfilePhotoFrame extends StatelessWidget {
  const ProfilePhotoFrame({required this.path, required this.url, super.key});

  final String? path;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96.w,
      height: 96.w,
      child: Stack(
        children: [
          Align(
            child: ProfileCircleAvatar(path: path, url: url, radius: 40),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: ProfileCameraBadge(),
          ),
        ],
      ),
    );
  }
}

class ProfileCameraBadge extends StatelessWidget {
  const ProfileCameraBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.grey.shade600),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Icon(Icons.photo_camera_outlined, size: 16.sp),
      ),
    );
  }
}

(String?, String?) _photo(EditProfileViewModel viewModel) {
  return (viewModel.state.photoPath, viewModel.state.profile.data?.photoUrl);
}

void _pick(BuildContext context) {
  context.read<EditProfileViewModel>().doEvent(const PhotoPickRequested());
}
