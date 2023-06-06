import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

class SubsTextField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization? textCapitalization;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final bool? autocorrect;
  final String? Function(String?)? validatorFunction;

  const SubsTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.onChanged,
    this.inputFormatters,
    this.autocorrect = true,
    this.validatorFunction,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      autocorrect: autocorrect!,
      enabled: enabled,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization!,
      style: Theme.of(context).textTheme.subtitle2,
      inputFormatters: inputFormatters,
      validator: validatorFunction,
      decoration: InputDecoration(
        filled: enabled ? false : true,
        fillColor: enabled ? null : ColorPalettes.disabledForm,
        suffixIcon: suffixIcon,
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: ColorPalettes.error,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: ColorPalettes.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: enabled
                  ? Colors.black.withOpacity(0.3)
                  : ColorPalettes.disabledFormText,
              fontWeight: enabled ? null : FontWeight.w600,
            ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: ColorPalettes.whiteGray,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
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
