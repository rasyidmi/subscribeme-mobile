import "package:flutter/material.dart";
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsSecondaryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonText;
  final ButtonStyle? buttonStyle;
  final double minWidth;
  final TextStyle? textStyle;

  const SubsSecondaryButton({
    Key? key,
    this.onTap,
    required this.buttonText,
    this.buttonStyle,
    this.minWidth = double.infinity,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: buttonStyle ??
          Theme.of(context).textButtonTheme.style!.copyWith(
              minimumSize: MaterialStateProperty.all(
                Size(minWidth, 44.0),
              ),
              backgroundColor:
                  const MaterialStatePropertyAll(ColorPalettes.secondary)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: textStyle ?? Theme.of(context).textTheme.button!.copyWith(
              color: ColorPalettes.primary
            ),
          ),
        ],
      ),
    );
  }
}
