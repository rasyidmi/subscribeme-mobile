import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subscribeme_mobile/commons/resources/icons.dart';

class PrimaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  const PrimaryAppbar({
    Key? key,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(SubsIcons.appBarLogo),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
