import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/domain/post_auth_route.dart';
import 'package:tracking_app/features/auth/presentation/login/view_model/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.viewModel});

  final LoginViewModel? viewModel;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final LoginViewModel _model;
  late final bool _ownsModel;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _ownsModel = widget.viewModel == null;
    _model = widget.viewModel ?? getIt<LoginViewModel>();
    _model.addListener(_onState);
  }

  @override
  void dispose() {
    _model.removeListener(_onState);
    if (_ownsModel) _model.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _body(context));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          if (context.canPop()) context.pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      title: Text(LocaleKeys.authLoginHeading.tr()),
    );
  }

  Widget _body(BuildContext context) {
    return ListenableBuilder(
      listenable: _model,
      builder: (context, _) => _form(context),
    );
  }

  Widget _form(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: _fields(context),
      ),
    );
  }

  Widget _fields(BuildContext context) {
    return Column(
      children: [
        _emailField(),
        SizedBox(height: 16.h),
        _passwordField(),
        _credentialError(),
        _rememberRow(context),
        _serverBanner(),
        SizedBox(height: 24.h),
        _continueButton(),
      ],
    );
  }

  Widget _emailField() {
    return AppTextField(
      label: LocaleKeys.authEmailLabel.tr(),
      hint: LocaleKeys.authEmailHint.tr(),
      controller: _email,
      validator: AppValidators.emailValidator,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: _onChanged,
    );
  }

  Widget _passwordField() {
    return AppTextField(
      label: LocaleKeys.authPassword.tr(),
      hint: LocaleKeys.authPasswordHint.tr(),
      controller: _password,
      validator: AppValidators.loginPasswordValidator,
      isPassword: true,
      textInputAction: TextInputAction.done,
      onChanged: _onChanged,
    );
  }

  Widget _rememberRow(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          activeColor: context.colors.pink,
          onChanged: (value) => setState(() => _rememberMe = value ?? false),
        ),
        Text(LocaleKeys.authRememberMe.tr()),
        const Spacer(),
        TextButton(onPressed: _onForgotPassword, child: _forgotLabel(context)),
      ],
    );
  }

  Widget _forgotLabel(BuildContext context) {
    return Text(
      LocaleKeys.authForgetPasswordLink.tr(),
      style: TextStyle(
        color: context.colors.pink,
        fontSize: 14.sp,
        decoration: TextDecoration.underline,
        decorationColor: context.colors.pink,
      ),
    );
  }

  Widget _continueButton() {
    final loading = _model.state.submission.isLoading;
    return AppButton(
      text: LocaleKeys.commonContinue.tr(),
      isLoading: loading,
      onPressed: _canSubmit && !loading ? _submit : null,
    );
  }

  Widget _credentialError() {
    final state = _model.state;
    if (!state.credentialFailure || state.submission.errorMessage.isEmpty) {
      return const SizedBox.shrink();
    }
    return _errorText(state.submission.errorMessage, 'credential-error');
  }

  Widget _serverBanner() {
    final state = _model.state;
    if (state.credentialFailure || state.submission.errorMessage.isEmpty) {
      return const SizedBox.shrink();
    }
    return _ServerErrorBanner(message: state.submission.errorMessage);
  }

  Widget _errorText(String message, String keyName) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        message,
        key: Key(keyName),
        style: TextStyle(color: context.colors.error, fontSize: 12.sp),
      ),
    );
  }

  bool get _canSubmit {
    return AppValidators.emailValidator(_email.text) == null &&
        AppValidators.loginPasswordValidator(_password.text) == null;
  }

  void _onChanged(String _) {
    _model.clearFailure();
    setState(() {});
  }

  void _onForgotPassword() {
    context.push(AppRoutes.forgetPassword);
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    await _model.submit(email: _email.text, password: _password.text);
  }

  void _onState() {
    final session = _model.state.submission.data;
    if (!mounted || session == null) return;
    context.go(resolveAuthenticatedRoute(session));
  }
}

class _ServerErrorBanner extends StatelessWidget {
  const _ServerErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('server-error-banner'),
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.colors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.colors.error),
      ),
      child: Text(message, style: TextStyle(color: context.colors.error)),
    );
  }
}
