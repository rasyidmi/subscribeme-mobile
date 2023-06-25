import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsFlushbar {
  static showSuccess(BuildContext context, String text) {
    Flushbar(
      backgroundColor: ColorPalettes.success,
      borderRadius: BorderRadius.circular(8),
      boxShadows: [
        BoxShadow(
          offset: const Offset(2, 4),
          blurRadius: 4,
          color: Colors.black.withOpacity(0.25),
        ),
      ],
      margin: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      shouldIconPulse: false,
      icon: const Icon(
        Icons.verified,
        color: Colors.white,
      ),
      messageText: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white)),
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  static showFailed(BuildContext context, String text) {
    Flushbar(
      backgroundColor: ColorPalettes.error,
      borderRadius: BorderRadius.circular(8),
      boxShadows: [
        BoxShadow(
          offset: const Offset(2, 4),
          blurRadius: 4,
          color: Colors.black.withOpacity(0.25),
        ),
      ],
      margin: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      shouldIconPulse: false,
      icon: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: FaIcon(
          FontAwesomeIcons.solidCircleXmark,
          color: Colors.white,
        ),
      ),
      messageText: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white)),
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  static showNotification(BuildContext context, String title, String body) {
    Flushbar(
      title: title,
      titleColor: ColorPalettes.dark70,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: Text(body,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: ColorPalettes.dark50)),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: ColorPalettes.white,
      borderRadius: BorderRadius.circular(8),
      boxShadows: [
        BoxShadow(
          offset: const Offset(2, 4),
          blurRadius: 4,
          color: Colors.black.withOpacity(0.25),
        ),
      ],
      margin: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 8.0,
      ),
      shouldIconPulse: false,
      icon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.notifications,
            color: ColorPalettes.primary,
            size: 28,
          )),
    ).show(context);
  }
}
