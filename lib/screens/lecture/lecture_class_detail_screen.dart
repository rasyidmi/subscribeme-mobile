import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/attendance/attendance_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/repositories/attendance_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/class_info_container.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';
import 'package:subscribeme_mobile/widgets/third_appbar.dart';

class LectureClassDetailScreen extends StatelessWidget {
  const LectureClassDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classData = ModalRoute.of(context)!.settings.arguments as Class;

    return BlocProvider<AttendanceBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<AttendanceRepository>(context);
        return AttendanceBloc(repository)
          ..add(FetchClassSession(classData.classCode));
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 24),
            ThirdAppbar(
              title: classData.name,
              subTitle: classData.courseName,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClassInfoContainer(
                        courseCode: classData.courseCode,
                        lectureName: classData.lectureName,
                        credit: classData.credit,
                        curriculumCode: classData.curriculumCode,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        height: 0,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            "Daftar Absensi",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed(Routes.addAttendance),
                            child: Text(
                              "+ Tambah Absen",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: ColorPalettes.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocBuilder<AttendanceBloc, AttendanceState>(
                        builder: (context, state) {
                          if (state is FetchClassSessionSuccess) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: state.sessionList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: SubsListTile(
                                    title: state.sessionList[index].openedTime!
                                        .getDateWithTime,
                                    secondLine:
                                        '${state.sessionList[index].totalPresent}/${state.sessionList[index].totalStudent} Mahasiswa',
                                    secondLineStyle:
                                        Theme.of(context).textTheme.subtitle2,
                                    thirdLine:
                                        'oleh ${_convertLectureName(classData.lectureName)}',
                                    thirdLineStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(color: ColorPalettes.gray),
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(Routes.lectureAttendance,
                                            arguments:
                                                state.sessionList[index].id),
                                    isActive: true,
                                  ),
                                );
                              },
                            );
                          } else {
                            return const ListShimmer(itemHeight: 64);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _convertLectureName(List<dynamic> lectures) {
    String convertedString = lectures[0]["name"];
    if (lectures.length > 1) {
      for (var i = 1; i < lectures.length; i++) {
        convertedString += ' & ${lectures[i]["name"]}';
      }
    }

    return convertedString;
  }
}
