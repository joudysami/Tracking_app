import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart' show AppRoutes;
import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/core/widgets/custom_button.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_event.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_state.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  late final LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loginViewModel = context.read<LoginViewModel>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.authLogin.tr()),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: BlocListener<LoginViewModel, LoginState>(
          listener: (BuildContext context, LoginState state) {
            print('Login State: ${state.loginState}');
            if (state.loginState.data != null &&
                state.loginState.isLoading == false) {
              context.go(AppRoutes.home);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: LocaleKeys.authEmail.tr(),
                      hint: LocaleKeys.authEnterEmail.tr(),
                      validator: AppValidators.emailValidator,
                      controller: _emailController,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      label: LocaleKeys.authPassword.tr(),
                      hint: LocaleKeys.authEnterPassword.tr(),
                      validator: AppValidators.passwordValidator,
                      controller: _passwordController,
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Row(
                          children: [
                            Checkbox(
                              activeColor: context.colors.pink,
                              side: BorderSide(
                                color: context.colors.grey[900] ?? Colors.grey,
                                width: 1.5.w,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Text(
                              LocaleKeys.rememberMe.tr(),
                              style: TextStyle(
                                color: context.colors.black,
                                fontSize: 14.sp,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                context.push(AppRoutes.forgetPassword);
                              },
                              child: Text(
                                LocaleKeys.authForgotPassword.tr(),
                                style: TextStyle(
                                  color: context.colors.pink,
                                  fontSize: 14.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: context.colors.pink,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<LoginViewModel, LoginState>(
                        builder: (context, state) {
                          return state.loginState.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: context.colors.pink,
                                  ),
                                )
                              : CustomButton(
                                  text: LocaleKeys.commonContinue.tr(),
                                  color: context.colors.white,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      loginViewModel.doEvent(
                                        LoginSubmitted(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}