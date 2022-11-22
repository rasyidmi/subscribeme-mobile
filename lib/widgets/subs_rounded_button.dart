import 'package:flutter/material.dart';

class SubsRoundedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? icon;
  final String buttonText;
  final bool isLoading;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final double minWidth;

  const SubsRoundedButton({
    Key? key,
    required this.buttonText,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.textStyle,
    this.buttonStyle,
    this.minWidth = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: !isLoading ? onTap : null,
      style: buttonStyle ??
          Theme.of(context).textButtonTheme.style!.copyWith(
                minimumSize: MaterialStateProperty.all(
                  Size(minWidth, 44.0),
                ),
              ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(width: 8.0),
          if (isLoading)
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 30,
                maxWidth: 30,
              ),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          if (!isLoading)
            Text(
              buttonText,
              style: textStyle ?? Theme.of(context).textTheme.button,
            ),
        ],
      ),
    );
  }
}
