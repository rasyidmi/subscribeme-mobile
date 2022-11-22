import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: ColorPalettes.primary,
      strokeWidth: 6,
    );
  }
}
