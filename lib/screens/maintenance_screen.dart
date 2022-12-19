import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
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
              LocaleKeys.maintenance_screen_under_maintenance.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: ColorPalettes.primary),
            ),
            const SizedBox(height: 16.0),
            Text(
              LocaleKeys.maintenance_screen_under_maintenance_2.tr(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }
}
