import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final bool centerTitle;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  const SecondaryAppbar({
    Key? key,
    required this.title,
    this.subTitle,
    this.padding = const EdgeInsets.only(top: 16.0),
    this.centerTitle = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: padding,
        child: Row(
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
                onPressed: onPressed ?? () {
                        Navigator.of(context).pop();
                      },
                icon: const Icon(Icons.arrow_back_ios_outlined),
              ),
            ),
            if (!centerTitle) const SizedBox(width: 16.0),
            if (centerTitle) const Spacer(),
            // Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                if (subTitle != null) const SizedBox(height: 4.0),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
              ],
            ),
            if (centerTitle) const Spacer(),
            if (centerTitle) const SizedBox(width: 52.0)
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
