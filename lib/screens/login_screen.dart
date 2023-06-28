// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/commons/resources/icons.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/services/secure_storage.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SubsConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (state.user.isExist!) {
              // If user already exist in DB, navigate to home.
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.main, (route) => false);
            } else {
              // Navigate to login confirmation.
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.loginConfirmation, (route) => false);
            }
          } else if (state is AuthFailed &&
              state.status == ResponseStatus.unauthorized) {
            log(state.message!);
          }
        },
        builder: ((context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: isLoading
                ? const Center(child: CircularLoading())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(SubsIcons.appBarLogo),
                      const SizedBox(height: 24.0),
                      SubsRoundedButton(
                        buttonText: "Login dengan SSO",
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          Navigator.of(context)
                              .pushNamed(Routes.ssoWebView)
                              .then(
                            (value) {
                              if (value != null) {
                                log(value.toString());
                                BlocProvider.of<AuthBloc>(context)
                                    .add(Login(value.toString()));
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          );
                        },
                      ),
                      SubsRoundedButton(
                        buttonText: "Dosen",
                        onTap: () async {
                          // FOR DEVELOPING, REFACTOR SOON
                          final LocalStorageService storageService =
                              LocalStorageService();
                          await storageService.writeSecureData("token",
                              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1hIjoiRHIuIElyLiBFcmRlZmkgUmFrdW4gTS5TYy4iLCJ1c2VybmFtZSI6ImlpcyIsIm5wbSI6IjEwMDIxMDUxMDI3MTYwOTU5MSIsImp1cnVzYW4iOnsiZmFjdWx0eSI6IklsbXUgS29tcHV0ZXIiLCJzaG9ydEZhY3VsdHkiOiJGYXNpbGtvbSIsIm1ham9yIjoiU2lzdGVtIEluZm9ybWFzaSAoSW5mb3JtYXRpb24gU3lzdGVtKSIsInByb2dyYW0iOiJTMSBQYXJhbGVsIChTMSBQYXJhbGVsKSJ9LCJyb2xlIjoiRG9zZW4iLCJleHAiOjE3MTc1ODAyNzd9.56Hw6udbWqQ0lWQUaSzkGh1T_5vnCiWUmV7p3Jx0Ir4");
                          Navigator.of(context).pushReplacementNamed("Wrapper");
                        },
                      )
                    ],
                  ),
          );
        }),
      )),
    );
  }
}
