import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../commons/styles/color_palettes.dart';

class BoxShimmer extends StatelessWidget {
  final double size;
  final double borderRadius;

  const BoxShimmer({
    Key? key,
    required this.size,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorPalettes.cloud,
      highlightColor: ColorPalettes.whiteGray,
      child: Container(
        height: size,
        width: size,
        color: ColorPalettes.cloud,
      ),
    );
  }
}
