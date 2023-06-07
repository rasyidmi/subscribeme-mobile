import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class ThirdOnboardingScreen extends StatelessWidget {
  final VoidCallback onTap;
  const ThirdOnboardingScreen({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(SubsImages.thirdOnboarding),
            fit: BoxFit.cover,
          ),
        ),
      child: Column(
        children: [
            const Spacer(),
          Image.asset(
            SubsImages.salyRun,
            height: getScreenSize(context).height * 0.3,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16),
            child: Text(
              "Tunggu Apa Lagi?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getScreenSize(context).width * 0.1),
            child: Text(
              "Tidak perlu menunggu lama, klik tombol selesai dan nikmati kemudahannya!",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: ColorPalettes.gray),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SubsRoundedButton(
              buttonText: "Selesai",
              onTap: onTap,
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
