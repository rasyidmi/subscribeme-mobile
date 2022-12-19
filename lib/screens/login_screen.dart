import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/commons/resources/icons.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _tryAutoLogin();
  }

  void _tryAutoLogin() {
    context.read<AuthBloc>().add(AutoLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubsConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigate to home screen
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.home, (route) => false);
            } else if (state is AuthFailed &&
                state.status != ResponseStatus.unauthorized) {
              SubsFlushbar.showFailed(context, state.message!);
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularLoading());
            } else {
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 24.0),
                          SvgPicture.asset(SubsIcons.appBarLogo),
                          const SizedBox(height: 24.0),
                          SubsTextField(
                            label: LocaleKeys.auth_screen_email.tr(),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            onChanged: (_) {
                              // To update the state of the save button when
                              // user change input
                              setState(() {});
                            },
                          ),
                          SubsTextField(
                            label: LocaleKeys.auth_screen_password.tr(),
                            obscureText: !isPasswordVisible,
                            controller: passwordController,
                            onChanged: (_) {
                              // To update the state of the save button when
                              // user change input
                              setState(() {});
                            },
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              child: Icon(
                                Icons.remove_red_eye,
                                color: isPasswordVisible
                                    ? ColorPalettes.primary
                                    : ColorPalettes.disabledButton,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              LocaleKeys.auth_screen_forgot_password.tr(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: ColorPalettes.textLink),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SubsRoundedButton(
                            buttonText: LocaleKeys.auth_screen_login.tr(),
                            onTap: _isFormFilled ? _login : null,
                          ),
                          const SizedBox(height: 24.0),
                          RichText(
                            text: TextSpan(
                              text: '${LocaleKeys.auth_screen_dont_have_an_account.tr()} ',
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(
                                  text: LocaleKeys.auth_screen_register.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: ColorPalettes.textLink),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context)
                                        .pushNamed(Routes.register),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _login() {
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    BlocProvider.of<AuthBloc>(context).add(Login(data));
  }

  bool get _isFormFilled {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }
}
