import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/service_locator/navigation_service.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_secondary_button.dart';

class LoginConfirmationScreen extends StatelessWidget {
  const LoginConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: ColorPalettes.primary,
      body: SubsConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is CreateUserSuccess) {
            // If creating user is success in BE, navigate to home screen.
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.home, (route) => false);
          }
        },
        builder: (context, state) {
          if (state is CreateUserLoading) {
            return const CircularProgressIndicator(color: Colors.white);
          }
          return Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  Image.asset(
                    SubsImages.salyRocket,
                    height: getScreenSize(context).height / 5,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Berhasil Masuk!",
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Aplikasi ini akan menyimpan data sso kamu untuk kebutuhan notifikasi, data yang disimpan hanya meliputi nama dan NPM.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                padding: EdgeInsets.only(bottom: bottomPadding, top: 16),
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    Expanded(
                      child: SubsSecondaryButton(
                        buttonText: "Tidak",
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.home, (route) => false);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SubsRoundedButton(
                        buttonText: "Simpan",
                        onTap: createUser,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> createUser() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log(fcmToken.toString());
    final currentContext =
        locator<NavigationService>().navigatorKey.currentContext;
    BlocProvider.of<AuthBloc>(currentContext!).add(CreateUser(fcmToken!));
  }
}
