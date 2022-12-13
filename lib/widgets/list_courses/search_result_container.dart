import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SearchResultContainer extends StatelessWidget {
  final Widget body;
  const SearchResultContainer({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16.0,
            color: ColorPalettes.white,
          ),
          Container(
            color: ColorPalettes.white,
            width: double.infinity,
            child: Text(
              'Hasil pencarian...',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
