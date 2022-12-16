import "package:flutter/material.dart";
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class MyClassScreen extends StatelessWidget {
  final PageController pageController;
  const MyClassScreen({
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
              'Kamu belum memiliki kelas saat ini',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: ColorPalettes.primary),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Pilih kelasmu sekarang dan dapatkan notifikasi tugasnya!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            SubsRoundedButton(
              buttonText: "Pilih Kelas",
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
