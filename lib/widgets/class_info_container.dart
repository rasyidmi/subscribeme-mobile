import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';

class ClassInfoContainer extends StatelessWidget {
  final String courseCode;
  final List<dynamic> lectureName;
  final int credit;
  const ClassInfoContainer({
    Key? key,
    required this.courseCode,
    required this.lectureName,
    required this.credit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.class_detail_screen_course_detail.tr(),
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ClassDetailInfoContainer(
          info: LocaleKeys.class_detail_screen_course_code.tr(),
          data: courseCode,
        ),
        const SizedBox(height: 8),
        ClassDetailInfoContainer(
          info: LocaleKeys.class_detail_screen_curriculum_code.tr(),
          data: "08.00.12.01-2020",
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.class_detail_screen_lecturer.tr()),
            const Spacer(),
            Expanded(
              flex: 2,
              child: Text(
                convertLectureName(lectureName),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClassDetailInfoContainer(
          info: LocaleKeys.class_detail_screen_credit.tr(),
          data: credit.toString(),
        ),
      ],
    );
  }

  String convertLectureName(List<dynamic> lectures) {
    String convertedString = lectures[0]["name"];
    if (lectures.length > 1) {
      for (var i = 1; i < lectures.length; i++) {
        convertedString += ' & ${lectures[i]["name"]}';
      }
    }

    return convertedString;
  }
}

class ClassDetailInfoContainer extends StatelessWidget {
  final String data;
  final String info;
  const ClassDetailInfoContainer({
    Key? key,
    required this.data,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(info),
        const Spacer(),
        Text(data),
      ],
    );
  }
}
