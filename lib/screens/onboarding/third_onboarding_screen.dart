import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class ThirdOnboardingScreen extends StatelessWidget {
  final VoidCallback onTap;
  const ThirdOnboardingScreen({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Image.asset(SubsImages.salyComputer),
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
    );
  }
}
