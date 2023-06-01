import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsFloatingActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const SubsFloatingActionButton({
    Key? key,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 44.0,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: onTap,
        backgroundColor: ColorPalettes.primary,
        child: Text(label),
      ),
    );
  }
}
