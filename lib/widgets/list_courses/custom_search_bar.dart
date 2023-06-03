import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsSearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  final String? hintText;
  const SubsSearchBar({
    Key? key,
    this.onChanged,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: ColorPalettes.dark50,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.only(right: 16),
        hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: ColorPalettes.whiteGray,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
        prefixIcon: const Icon(Icons.search, color: ColorPalettes.dark50),
        filled: true,
        fillColor: ColorPalettes.white,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: ColorPalettes.whiteGray,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            width: 2.0,
            color: ColorPalettes.primary,
          ),
        ),
      ),
    );
  }
}
