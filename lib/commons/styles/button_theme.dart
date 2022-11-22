part of 'themes.dart';

TextButtonThemeData _buttonTheme = TextButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return ColorPalettes.disabledButton;
        }
        return ColorPalettes.primary;
      },
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
  ),
);
