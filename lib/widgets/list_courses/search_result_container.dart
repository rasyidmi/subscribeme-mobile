import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
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
              LocaleKeys.search_result.tr(),
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
