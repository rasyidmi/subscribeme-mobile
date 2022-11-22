import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(SubsImages.salyRocket),
            const SizedBox(height: 16.0),
            Text(
              'Aplikasi sedang dalam tahap perbaikan',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: ColorPalettes.primary),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Saat ini aplikasi sedang dilakukan pengembangan dan perbaikan dari sistem yang ada. Silahkan kembali dalam beberapa saat lagi.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }
}
