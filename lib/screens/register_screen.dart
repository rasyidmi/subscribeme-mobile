import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SecondaryAppbar(
        title: 'Daftar',
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _registerFormKey,
                child: Column(
                  children: [
                    SubsTextField(
                      label: 'Email',
                      hintText: 'bob.ganteng@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      onChanged: (_) {
                        // To update the state of the save button when
                        // user change input
                        setState(() {});
                      },
                    ),
                    SubsTextField(
                      label: 'Nama',
                      hintText: 'Bob Andriqa',
                      controller: nameController,
                      inputFormatters: [LengthLimitingTextInputFormatter(35)],
                      onChanged: (_) {
                        // To update the state of the save button when
                        // user change input
                        setState(() {});
                      },
                    ),
                    SubsTextField(
                      label: 'Kata Sandi',
                      obscureText: !isPasswordVisible,
                      controller: passwordController,
                      validatorFunction: (value) {
                        if (value!.length < 8) {
                          return '*Panjang kata sandi harus lebih dari 8';
                        }
                        return null;
                      },
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
                    SubsTextField(
                      label: 'Konfirmasi Kata Sandi',
                      obscureText: !isConfirmPasswordVisible,
                      controller: confirmPasswordController,
                      validatorFunction: (value) {
                        if (value != passwordController.text) {
                          return '*Kata sandi yang telah dimasukkan berbeda';
                        } else if (value!.length < 8) {
                          return '*Panjang kata sandi harus lebih dari 8';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        // To update the state of the save button when
                        // user change input
                        setState(() {});
                      },
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: isConfirmPasswordVisible
                              ? ColorPalettes.primary
                              : ColorPalettes.disabledButton,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    // const Spacer(),
                    SubsConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is RegisterSuccess) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.login, (route) => false);
                          SubsFlushbar.showSuccess(
                            context,
                            'Akun berhasil dibuat',
                          );
                        } else if (state is RegisterFailed) {
                          setState(() {
                            _isLoading = false;
                          });
                          SubsFlushbar.showFailed(
                            context,
                            state.message != null ? state.message! : "",
                          );
                        }
                      },
                      builder: (context, state) {
                        return SubsRoundedButton(
                          isLoading: _isLoading,
                          buttonText: 'Daftar',
                          onTap: _isFormFilled ? _register : null,
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                    SafeArea(
                      child: RichText(
                        text: TextSpan(
                          text: 'Sudah punya akun? ',
                          style: Theme.of(context).textTheme.bodyText2,
                          children: [
                            TextSpan(
                              text: ' Masuk',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: ColorPalettes.textLink),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context)
                                    .pushNamed(Routes.login),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _register() {
    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final Map<String, dynamic> data = {
        'email': emailController.text,
        'name': nameController.text,
        'password': passwordController.text,
        // Role default adalah user biasa
        'role': 'student',
        'confirmPassword': confirmPasswordController.text,
      };
      log(data.toString());
      BlocProvider.of<AuthBloc>(context).add(Register(data));
    }
  }

  bool get _isFormFilled {
    return emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }
}
