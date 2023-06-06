import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsAlertDialog extends StatelessWidget {
  final List<InlineSpan>? textSpan;
  final VoidCallback? onTap;
  const SubsAlertDialog({
    Key? key,
    this.textSpan,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: SizedBox(
        width: getScreenSize(context).width / 1.725,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: textSpan,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(
              height: 0.0,
              thickness: 1.0,
              color: ColorPalettes.whiteGray,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: Text(
                      "Kembali",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: ColorPalettes.gray),
                    ),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: ColorPalettes.primary.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(16.0)),
                    ),
                    child: Text(
                      "Hapus",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: ColorPalettes.primary),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
