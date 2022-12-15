import "package:flutter/material.dart";

class RectangleButton extends StatelessWidget {
  final Color backgroundColor;
  final Icon icon;
  final VoidCallback? onTap;
  const RectangleButton({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
          color: backgroundColor,
        ),
        child: icon,
      ),
    );
  }
}
