import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:subscribeme_mobile/blocs/attendance/attendance_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/repositories/attendance_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/bottom_button_container.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/class_info_container.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classData = ModalRoute.of(context)!.settings.arguments as Class;

    return BlocProvider<AttendanceBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<AttendanceRepository>(context);
        return AttendanceBloc(repository)
          ..add(FetchClassDetailData(classData.classCode));
      },
      child: Scaffold(
        appBar: SecondaryAppbar(
          title: 'Kelas ${classData.name[classData.name.length - 1]}',
          subTitle: classData.courseName,
          padding: const EdgeInsets.only(top: 8.0),
        ),
        body: SubsConsumer<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is RecordAttendanceLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                useSafeArea: false,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: const Center(
                      child: CircularLoading(),
                    ),
                  );
                },
              );
            } else if (state is RecordAttendanceSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.classDetail,
                  (route) => route.settings.name == Routes.main,
                  arguments: classData);
              SubsFlushbar.showSuccess(context, "Absensi berhasil dilakukan");
            } else if (state is RecordAttendanceFailed) {
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.classDetail,
                  (route) => route.settings.name == Routes.main,
                  arguments: classData);
              SubsFlushbar.showFailed(context, "Absensi gagal dilakukan");
            }
          },
          builder: (context, state) {
            if (state is FetchClassDetailDataSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            // CLASS DETAIL INFO
                            ClassInfoContainer(
                              courseCode: classData.courseCode,
                              lectureName: classData.lectureName,
                              credit: classData.credit,
                              curriculumCode: classData.curriculumCode,
                            ),
                            const SizedBox(height: 20),
                            const Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            const SizedBox(height: 20),
                            // CLASS SCHEDULE
                            Text(
                              "Jadwal Kelas",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            // CLASS SCHEDULE
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: classData.schedule!.length,
                              itemBuilder: (context, index) {
                                return OutlinedContainer(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined),
                                      const SizedBox(width: 8),
                                      Text(
                                          '${classData.schedule![index].day}, ${classData.schedule![index].startTime.substring(0, 5)} - ${classData.schedule![index].endTime.substring(0, 5)}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 26),
                            const Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            const SizedBox(height: 22),
                            // ATTENDANCE HISTORY
                            Text(
                              "Riwayat Absensi",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.attendanceList.length,
                              itemBuilder: (context, index) {
                                return OutlinedContainer(
                                    child: AttendanceItem(
                                  isAttend:
                                      state.attendanceList[index].isAttend,
                                  openedTime: state
                                      .attendanceList[index].openedTime.getDate,
                                  recordTime:
                                      state.attendanceList[index].recordTime,
                                ));
                              },
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BottomContainer(
                    child: Column(
                      children: [
                        SubsRoundedButton(
                          buttonText: "Absen Kelas Ini",

                          /// If slot is opened and user not record his/her attendance yet,
                          /// enable attendance.
                          onTap: (state.attendanceSlot != null &&
                                  state.attendanceSlot!.isOpen! &&
                                  !state
                                      .attendanceList[
                                          state.attendanceList.length - 1]
                                      .isAttend)
                              ? () {
                                  BlocProvider.of<AttendanceBloc>(context)
                                      .add(RecordAttendance(
                                    sessionId: state.attendanceSlot!.id,
                                    isGeofence:
                                        state.attendanceSlot!.isGeofence,
                                  ));
                                }
                              : null,
                        ),
                        BottomText(
                            enabled: state.attendanceSlot != null &&
                                  state.attendanceSlot!.isOpen! &&
                                  !state
                                      .attendanceList[
                                          state.attendanceList.length - 1]
                                      .isAttend),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListShimmer(itemHeight: 64),
              );
            }
          },
        ),
      ),
    );
  }
}

class BottomText extends StatelessWidget {
  final bool enabled;
  const BottomText({Key? key, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          enabled ? Icons.check_circle : Icons.info_outline,
          color: enabled ? ColorPalettes.success : ColorPalettes.lightRed,
          size: 16,
        ),
        const SizedBox(width: 10),
        Text(
          enabled ? "Absensi tersedia" : "Absensi selanjutnya belum tersedia",
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: !enabled ? ColorPalettes.lightRed : null),
        ),
      ],
    );
  }
}

class OutlinedContainer extends StatelessWidget {
  final Widget child;
  const OutlinedContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: ColorPalettes.whiteGray),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: child,
    );
  }
}

class AttendanceItem extends StatelessWidget {
  final bool isAttend;
  final String openedTime;
  final DateTime? recordTime;
  const AttendanceItem({
    Key? key,
    required this.isAttend,
    required this.openedTime,
    this.recordTime,
  })  : assert(
            isAttend && recordTime != null || !isAttend && recordTime == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isAttend ? Icons.check_circle : Icons.do_not_disturb_on,
          color: isAttend ? ColorPalettes.success : ColorPalettes.gray,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Text(
                    isAttend ? "Hadir" : "Tidak Hadir",
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isAttend
                              ? ColorPalettes.success
                              : ColorPalettes.gray,
                        ),
                  ),
                  VerticalDivider(
                    color: isAttend ? Colors.black : ColorPalettes.gray,
                    endIndent: 2,
                    indent: 2,
                  ),
                  Text(
                    openedTime,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: isAttend
                            ? ColorPalettes.success
                            : ColorPalettes.gray),
                  ),
                ],
              ),
            ),
            Text(
              'Jam Absensi: ${recordTime != null ? recordTime!.displayHourMinute : "-"}',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: isAttend ? ColorPalettes.success : ColorPalettes.gray),
            ),
          ],
        ),
      ],
    );
  }
}
