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
    minimumSize: MaterialStateProperty.all(
      const Size(double.infinity, 44.0),
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
  ),
);
