import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../commons/styles/color_palettes.dart';

class RectangleShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const RectangleShimmer({
    Key? key,
    required this.height,
    required this.width,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorPalettes.cloud,
      highlightColor: ColorPalettes.whiteGray,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          width: width,
          color: ColorPalettes.cloud,
        ),
      ),
    );
  }
}
