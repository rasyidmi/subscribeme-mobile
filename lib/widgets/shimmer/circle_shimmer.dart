import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class CircleShimmer extends StatelessWidget {
  final double size;
  const CircleShimmer({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorPalettes.cloud,
      highlightColor: ColorPalettes.whiteGray,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: ColorPalettes.cloud,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
