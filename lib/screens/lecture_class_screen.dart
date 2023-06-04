import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/widgets/list_courses/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/primary_appbar.dart';

class LectureClassScreen extends StatefulWidget {
  const LectureClassScreen({Key? key}) : super(key: key);

  @override
  State<LectureClassScreen> createState() => _LectureClassScreenState();
}

class _LectureClassScreenState extends State<LectureClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 38),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SubsSearchBar(
                  hintText: LocaleKeys.list_course_screen_search_course.tr()),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
