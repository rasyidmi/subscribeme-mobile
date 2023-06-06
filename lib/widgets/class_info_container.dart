import 'package:flutter/material.dart';

class ClassInfoContainer extends StatelessWidget {
  final String courseCode;
  final List<dynamic> lectureName;
  final int credit;
  final String curriculumCode;
  const ClassInfoContainer({
    Key? key,
    required this.courseCode,
    required this.lectureName,
    required this.credit,
    required this.curriculumCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Detail Mata Kuliah",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ClassDetailInfoContainer(
          info: "Kode Mata Kuliah",
          data: courseCode,
        ),
        const SizedBox(height: 8),
        ClassDetailInfoContainer(
          info: "Kode Kurikulum",
          data: curriculumCode,
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dosen Pengajar"),
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
          info: "SKS",
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
