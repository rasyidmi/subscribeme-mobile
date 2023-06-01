import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classData = ModalRoute.of(context)!.settings.arguments as Class;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: SecondaryAppbar(
        title: 'Kelas ${classData.name[classData.name.length - 1]}',
        subTitle: classData.courseName,
        padding: const EdgeInsets.only(top: 8.0),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      LocaleKeys.class_detail_screen_course_detail.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(LocaleKeys.class_detail_screen_course_code.tr()),
                        const Spacer(),
                        Text(classData.courseCode),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(LocaleKeys.class_detail_screen_curriculum_code
                            .tr()),
                        const Spacer(),
                        Text("08.00.12.01-2020"),
                      ],
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
                            convertLectureName(classData.lectureName),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(LocaleKeys.class_detail_screen_credit.tr()),
                        const Spacer(),
                        Text(classData.credit.toString()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      height: 0,
                      thickness: 2,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.class_detail_screen_class_schedule.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: classData.schedule.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorPalettes.whiteGray),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined),
                              const SizedBox(width: 8),
                              Text(
                                  '${classData.schedule[index].day}, ${classData.schedule[index].startTime.substring(0, 5)} - ${classData.schedule[index].endTime.substring(0, 5)}'),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 26),
                    const Divider(
                      height: 0,
                      thickness: 2,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      LocaleKeys.class_detail_screen_attendance_history.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorPalettes.whiteGray),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: ColorPalettes.success,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Text(
                                          LocaleKeys.class_detail_screen_present
                                              .tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: ColorPalettes.success,
                                              ),
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black,
                                          endIndent: 2,
                                          indent: 2,
                                        ),
                                        Text(
                                          "Jumat, 28 Desember 2023",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Jam Absensi: 08.12",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -1),
                    blurRadius: 24,
                    spreadRadius: 0.5,
                    color: Colors.black.withOpacity(0.15),
                  ),
                ]),
            padding: EdgeInsets.only(
              bottom: bottomPadding,
              top: 16,
              right: 24,
              left: 24,
            ),
            child: Column(
              children: [
                SubsRoundedButton(
                  buttonText: LocaleKeys.class_detail_screen_attend_class.tr(),
                  onTap: () {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: ColorPalettes.success,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      LocaleKeys.class_detail_screen_attendance_available.tr(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
