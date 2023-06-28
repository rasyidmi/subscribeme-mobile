// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/commons/constants/role.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({Key? key}) : super(key: key);

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login screen.
    handleLanding();
  }

  Future<void> handleLanding() async {
    Timer(
      const Duration(milliseconds: 2000),
      () {
        context.read<AuthBloc>().add(AutoLogin());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubsConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          log("Auto login success");
          FlutterNativeSplash.remove();
          if (state.user.role == Role.student) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.main, (route) => false);
          } else if (state.user.role == Role.lecturer) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.lecture, (route) => false);
          }
        } else if (state is AuthFailed &&
            state.status == ResponseStatus.unauthorized) {
          log("Auto login failed");
          // If first install, navigate to onboarding page.
          bool firstCall = await IsFirstRun.isFirstCall();
          log('The app is running for the first time: $firstCall');
          FlutterNativeSplash.remove();
          if (firstCall) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.onBoarding, (route) => false);
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.login, (route) => false);
          }
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: CircularLoading()),
        );
      },
    );
  }
}
