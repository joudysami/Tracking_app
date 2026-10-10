import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/widgets/apply_vehicle_section.dart';

class ApplyBody extends StatefulWidget {
  const ApplyBody({super.key});

  @override
  State<ApplyBody> createState() => _ApplyBodyState();
}

class _ApplyBodyState extends State<ApplyBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ApplyViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 16.h),
              _buildNameFields(viewModel),
              SizedBox(height: 16.h),
              ApplyVehicleSection(viewModel: viewModel),
              SizedBox(height: 16.h),
              _buildPersonalFields(viewModel),
              SizedBox(height: 16.h),
              _buildPasswordFields(viewModel),
              SizedBox(height: 16.h),
              _buildGender(viewModel),
              SizedBox(height: 24.h),
              _buildSubmitButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.applyWelcome.tr(),
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.h),
        Text(
          LocaleKeys.applySubtitle.tr(),
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildNameFields(ApplyViewModel viewModel) {
    return Column(
      children: [
        AppTextField(
          label: LocaleKeys.applyFirstLegalName.tr(),
          hint: LocaleKeys.applyFirstLegalNameHint.tr(),
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            viewModel.doEvent(FirstNameChanged(value));
          },
          validator: (value) => AppValidators.requiredField(
            value,
            field: LocaleKeys.applyFirstLegalName.tr(),
          ),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: LocaleKeys.applySecondLegalName.tr(),
          hint: LocaleKeys.applySecondLegalNameHint.tr(),
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            viewModel.doEvent(LastNameChanged(value));
          },
          validator: (value) => AppValidators.requiredField(
            value,
            field: LocaleKeys.applySecondLegalName.tr(),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalFields(ApplyViewModel viewModel) {
    return Column(
      children: [
        AppTextField(
          label: LocaleKeys.authEmail.tr(),
          hint: LocaleKeys.applyEmailHint.tr(),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            viewModel.doEvent(EmailChanged(value));
          },
          validator: AppValidators.emailValidator,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: LocaleKeys.authPhone.tr(),
          hint: LocaleKeys.applyPhoneHint.tr(),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            viewModel.doEvent(PhoneChanged(value));
          },
          validator: AppValidators.phoneValidator,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: LocaleKeys.applyIdNumber.tr(),
          hint: LocaleKeys.applyIdNumberHint.tr(),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            viewModel.doEvent(NidChanged(value));
          },
          validator: AppValidators.validateNationalId,
        ),
        SizedBox(height: 16.h),
        BlocBuilder<ApplyViewModel, ApplyState>(
          buildWhen: (previous, current) =>
              previous.idImage != current.idImage,
          builder: (context, state) {
            return _buildImageField(
              label: LocaleKeys.applyIdImage.tr(),
              hint: LocaleKeys.applyIdImageHint.tr(),
              file: state.idImage == null ? null : File(state.idImage!),
              onTap: () {
                viewModel.doEvent(PickIdImageRequested());
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPasswordFields(ApplyViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppTextField(
            label: LocaleKeys.authPassword.tr(),
            hint: LocaleKeys.applyPasswordHint.tr(),
            isPassword: true,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              viewModel.doEvent(PasswordChanged(value));
            },
            validator: AppValidators.registrationPasswordValidator,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppTextField(
            label: LocaleKeys.authConfirmPassword.tr(),
            hint: LocaleKeys.applyConfirmPasswordHint.tr(),
            isPassword: true,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              viewModel.doEvent(ConfirmPasswordChanged(value));
            },
            validator: (value) => AppValidators.confirmPasswordValidator(
              value,
              viewModel.state.password,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGender(ApplyViewModel viewModel) {
    return BlocBuilder<ApplyViewModel, ApplyState>(
      buildWhen: (previous, current) => previous.gender != current.gender,
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                LocaleKeys.applyGender.tr(),
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(width: 16.w),
              for (final gender in [Gender.female, Gender.male]) ...[
                Radio<Gender>(
                  value: gender,
                  groupValue: state.gender,
                  onChanged: (value) {
                    if (value != null) {
                      viewModel.doEvent(GenderChanged(value));
                    }
                  },
                ),
                Text(
                  gender == Gender.female
                      ? LocaleKeys.applyFemale.tr()
                      : LocaleKeys.applyMale.tr(),
                ),
                SizedBox(width: 8.w),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(ApplyViewModel viewModel) {
    return BlocBuilder<ApplyViewModel, ApplyState>(
      buildWhen: (previous, current) =>
          previous.applyState.isLoading != current.applyState.isLoading,
      builder: (context, state) {
        return AppButton(
          text: LocaleKeys.commonContinue.tr(),
          isLoading: state.applyState.isLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              viewModel.doEvent(ApplyRequested());
            }
          },
        );
      },
    );
  }

  Widget _buildImageField({
    required String label,
    required String hint,
    required File? file,
    required VoidCallback onTap,
  }) {
    return AppTextField(
      key: ValueKey(file?.path),
      label: label,
      hint: hint,
      initialValue: file?.path.split(RegExp(r'[/\\]')).last,
      readOnly: true,
      onTap: onTap,
      suffixIcon: const Icon(Icons.upload_outlined),
      validator: (value) => AppValidators.requiredField(
        value,
        field: label,
      ),
    );
  }
}
