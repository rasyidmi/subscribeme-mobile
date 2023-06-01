import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/service_locator/navigation_service.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';
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
      listener: (context, state) {
        if (state is LoginSuccess) {
          log("Auto login success");
          FlutterNativeSplash.remove();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.home, (route) => false);
        } else if (state is AuthFailed &&
            state.status == ResponseStatus.unauthorized) {
          log("Auto login failed");
          FlutterNativeSplash.remove();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.login, (route) => false);
        }
      },
      builder: (context, state) {
        return Container();
      },
    );
  }
}
