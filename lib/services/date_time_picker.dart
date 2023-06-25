import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final selecetedDate = await showDatePicker(
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorPalettes.primary, // header background color
            onPrimary: ColorPalettes.white, // header text color
            onSurface: ColorPalettes.primary, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorPalettes.primary, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime.now().add(const Duration(days: 30)),
    locale: const Locale("id", "ID"),
  );
  if (selecetedDate == null) return null;

  final selectedTime = await showTimePicker(
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorPalettes.primary, // header background color
            onPrimary: ColorPalettes.white, // header text color
            onSurface: ColorPalettes.primary, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorPalettes.primary, // button text color
            ),
          ),
          timePickerTheme: TimePickerThemeData(
            dialBackgroundColor: ColorPalettes.primary.withOpacity(0.1),
            hourMinuteColor: ColorPalettes.primary.withOpacity(0.1),
          ),
        ),
        child: child!,
      );
    },
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (selectedTime == null) return null;

  return selecetedDate
      .add(Duration(hours: selectedTime.hour, minutes: selectedTime.minute));
}
