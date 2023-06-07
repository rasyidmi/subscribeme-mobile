import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class FirstOnboardingScreen extends StatelessWidget {
  final VoidCallback onTap;
  const FirstOnboardingScreen({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(SubsImages.firstOnboarding),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              SubsImages.salySorry,
              height: getScreenSize(context).height * 0.3,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Selamat Datang di SubscribeMe!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getScreenSize(context).width * 0.1),
              child: Text(
                "Aplikasi yang akan membuat perkuliahan kamu lebih mudah!",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: ColorPalettes.gray),
              ),
            ),
            const Spacer(),
            SubsRoundedButton(
              buttonText: "Mulai",
              onTap: onTap,
            ),
            SizedBox(height: bottomPadding),
          ],
        ),
      ),
    );
  }
}
