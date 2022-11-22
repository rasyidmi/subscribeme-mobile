import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get displayDeadline {
    final difference = this.difference(DateTime.now()).inDays;
    if (difference == 0) {
      final hourMinuteFormat =
          DateFormat('HH.mm').format(add(const Duration(hours: 7)));
      return 'Hari ini - $hourMinuteFormat';
    } else {
      final customFormat =
          DateFormat('HH.mm (d MMMM y)').format(add(const Duration(hours: 7)));
      return '$difference Hari Lagi - $customFormat';
    }
  }

  String get toDayMonthYearFormat {
    return DateFormat('d MMMM y').format(this);
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String get to24HourFormat {
    String hour = this.hour < 10 ? '0${this.hour}' : '${this.hour}';
    String minute = this.minute < 10 ? '0${this.minute}' : '${this.minute}';

    return '$hour:$minute';
  }
}
