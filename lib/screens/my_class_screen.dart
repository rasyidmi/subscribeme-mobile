import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class AttendanceScreen extends StatelessWidget {
  final PageController pageController;
  const AttendanceScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              SubsImages.salySorry,
              height: getScreenSize(context).height / 4,
            ),
            const SizedBox(height: 16.0),
            Text(
              LocaleKeys.my_class_screen_dont_have_class.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: ColorPalettes.primary),
            ),
            const SizedBox(height: 16.0),
            Text(
              LocaleKeys.my_class_screen_choose_class_now.tr(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            SubsRoundedButton(
              buttonText: LocaleKeys.my_class_screen_choose_class.tr(),
              onTap: () {
                pageController.jumpToPage(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
