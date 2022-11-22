import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class TimeFormContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Text text;
  const TimeFormContainer({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: ColorPalettes.whiteGray,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            Icon(
              icon,
              color: ColorPalettes.primary,
            ),
            const SizedBox(width: 24.0),
            text,
          ],
        ),
      ),
    );
  }
}
