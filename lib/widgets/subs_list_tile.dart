import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/extensions/string_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsListTile extends StatelessWidget {
  final String title;
  final FontWeight? titleWeight;
  final String? secondLine;
  final String? thirdLine;
  final String? fourthLine;
  final List<Widget>? actionButtons;
  final VoidCallback? onTap;
  final bool isActive;
  final double? fontSize;

  const SubsListTile({
    Key? key,
    required this.title,
    this.secondLine,
    this.thirdLine,
    this.fourthLine,
    this.actionButtons,
    this.onTap,
    this.isActive = false,
    this.titleWeight = FontWeight.bold,
    this.fontSize,
  })  : assert(onTap != null && isActive || onTap == null && !isActive),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: !isActive ? ColorPalettes.disabledColor : null,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: ColorPalettes.whiteGray),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: titleWeight,
                          fontSize: fontSize,
                          color: !isActive ? ColorPalettes.gray : null,
                        ),
                  ),
                  const SizedBox(height: 2.0),
                  if (!secondLine.isNull) ...[
                    Text(secondLine!,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: !isActive ? ColorPalettes.gray : null,
                              fontSize: fontSize,
                            )),
                    const SizedBox(height: 2.0),
                  ],
                  const SizedBox(height: 2.0),
                  if (!thirdLine.isNull) ...[
                    Text(thirdLine!,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: !isActive ? ColorPalettes.gray : null,
                              fontSize: fontSize,
                            )),
                    const SizedBox(height: 2.0),
                  ],
                  if (!fourthLine.isNull) ...[
                    Text(
                      fourthLine!,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: !isActive ? ColorPalettes.gray : null,
                            fontSize: fontSize,
                          ),
                    ),
                    const SizedBox(height: 2.0),
                  ],
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
            // const Spacer(),
            if (actionButtons != null) ...actionButtons!,
            const SizedBox(width: 20.0),
          ],
        ),
      ),
    );
  }
}
