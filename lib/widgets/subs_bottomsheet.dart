import "package:flutter/material.dart";
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsBottomsheet extends StatelessWidget {
  final List<Widget> content;
  const SubsBottomsheet({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 15,
      ),
      height: getScreenSize(context).height / 1.75,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: getScreenSize(context).width / 8,
              height: 4,
              color: ColorPalettes.gray2,
            ),
          ),
          ...content
        ],
      ),
    );
  }
}
