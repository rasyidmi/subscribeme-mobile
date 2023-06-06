import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/screens/onboarding/first_onboarding_screen.dart';
import 'package:subscribeme_mobile/screens/onboarding/second_onboarding_screen.dart';
import 'package:subscribeme_mobile/screens/onboarding/third_onboarding_screen.dart';
import 'package:subscribeme_mobile/widgets/primary_appbar.dart';

class OnboardingMainScreen extends StatefulWidget {
  const OnboardingMainScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingMainScreen> createState() => _OnboardingMainScreenState();
}

class _OnboardingMainScreenState extends State<OnboardingMainScreen> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PrimaryAppbar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: InkWell(
              onTap: () => _pageController.animateToPage(
                2,
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
              ),
              child: Text(
                "Lewati",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.bold, color: ColorPalettes.primary),
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          FirstOnboardingScreen(
            onTap: () => _pageController.animateToPage(
              1,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            ),
          ),
          SecondOnboardingScreen(
            onTap: () => _pageController.animateToPage(
              2,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            ),
          ),
          ThirdOnboardingScreen(
            onTap: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.login, (route) => false),
          ),
        ],
      ),
    );
  }
}
