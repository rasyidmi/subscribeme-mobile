import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get displayDeadline {
    final difference = this.difference(DateTime.now());
    if (difference.isNegative) {
      final customFormat =
          DateFormat('HH.mm (d MMMM y)', "id_ID").format(toLocal());
      return 'Sudah lewat - $customFormat';
    } else if (difference.inDays > 0) {
      final customFormat =
          DateFormat('HH.mm (d MMMM y)', "id_ID").format(toLocal());
      return '${difference.inDays} Hari Lagi - $customFormat';
    } else {
      final hourMinuteFormat = DateFormat('HH.mm', "id_ID").format(toLocal());
      return 'Hari ini - $hourMinuteFormat';
    }
  }

  String get toDayMonthYearFormat {
    return DateFormat('d MMMM y', "id_ID").format(toLocal());
  }

  String get displayHourMinute {
    return DateFormat('HH.mm', "id_ID").format(toLocal());
  }

  String get displayHourMinute2 {
    return DateFormat('HH:mm', "id_ID").format(toLocal());
  }

  String get getDateWithTime {
    return DateFormat('EEEE, d MMMM y - HH:mm', "id_ID").format(toLocal());
  }

  String get getDate {
    return DateFormat('EEEE, d MMMM y', "id_ID").format(toLocal());
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String get to24HourFormat {
    String hour = this.hour < 10 ? '0${this.hour}' : '${this.hour}';
    String minute = this.minute < 10 ? '0${this.minute}' : '${this.minute}';

    return '$hour:$minute';
  }
}
