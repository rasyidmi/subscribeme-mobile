import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class SecondOnboardingScreen extends StatelessWidget {
  final VoidCallback onTap;
  const SecondOnboardingScreen({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(SubsImages.secondOnboarding),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(
            SubsImages.salyComputer,
            height: getScreenSize(context).height * 0.3,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16),
            child: Text(
              "Terima Notifikasi Perkuliahan Secara Otomatis",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getScreenSize(context).width * 0.1),
            child: Text(
              "Kamu akan menerima notifikasi seputar tugas, kuis, dan absensi hanya dengan sekali klik saja!",
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
              buttonText: "Selanjutnya",
              onTap: onTap,
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
