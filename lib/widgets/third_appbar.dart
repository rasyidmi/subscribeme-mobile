import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class ThirdAppbar extends StatelessWidget {
  final String title;
  final String? subTitle;
  const ThirdAppbar({
    Key? key,
    required this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16.0),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              border: Border.all(color: ColorPalettes.whiteGray),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 16.0,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_outlined),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: ColorPalettes.primary),
                ),
                if (subTitle != null) const SizedBox(height: 4),
                if (subTitle != null) Text(subTitle!)
              ],
            ),
          )
        ],
      ),
    );
  }
}
