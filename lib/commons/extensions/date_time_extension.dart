import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';

extension DateTimeExtension on DateTime {
  String get displayDeadline {
    final difference = this.difference(DateTime.now());
    if (difference.isNegative) {
      final customFormat =
          DateFormat('HH.mm (d MMMM y)').format(add(const Duration(hours: 7)));
      return 'Sudah lewat - $customFormat';
    } else if (difference.inDays > 0) {
      final customFormat =
          DateFormat('HH.mm (d MMMM y)').format(add(const Duration(hours: 7)));
      return '${difference.inDays} ${LocaleKeys.more_days.tr()} - $customFormat';
    } else {
      final hourMinuteFormat =
          DateFormat('HH.mm').format(add(const Duration(hours: 7)));
      return '${LocaleKeys.today.tr()} - $hourMinuteFormat';
    }
  }

  String get toDayMonthYearFormat {
    return DateFormat('d MMMM y').format(add(const Duration(hours: 7)));
  }

  String get displayHourMinute {
    return DateFormat('HH.mm').format(this);
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String get to24HourFormat {
    String hour = this.hour < 10 ? '0${this.hour}' : '${this.hour}';
    String minute = this.minute < 10 ? '0${this.minute}' : '${this.minute}';

    return '$hour:$minute';
  }
}
