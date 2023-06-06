import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/attendance/attendance_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/models/attendance.dart';
import 'package:subscribeme_mobile/repositories/attendance_repository.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/third_appbar.dart';

class LectureAttendanceScreen extends StatefulWidget {
  const LectureAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<LectureAttendanceScreen> createState() =>
      _LectureAttendanceScreenState();
}

class _LectureAttendanceScreenState extends State<LectureAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    final sessionId = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider<AttendanceBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<AttendanceRepository>(context);
        return AttendanceBloc(repository)..add(FetchClassAbsence(sessionId));
      },
      child: Scaffold(
        body: SafeArea(
          child: SubsConsumer<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
              if (state is FetchClassAbsenceSuccess) {
                final openedTime =
                    state.sessionData["sessionData"].openedTime as DateTime;
                final isOpen = state.sessionData["sessionData"].isOpen as bool;
                final duration =
                    state.sessionData["sessionData"].duration as int;
                final isGeofence =
                    state.sessionData["sessionData"].isGeofence as bool;
                final presentList =
                    state.sessionData["presentList"] as List<Attendance>;
                final notPresentList =
                    state.sessionData["notPresentList"] as List<Attendance>;

                return DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              const SizedBox(height: 24),
                              ThirdAppbar(
                                title: openedTime.getDate,
                                subTitle: "Absensi Mahasiswa",
                              ),
                              const SizedBox(height: 30),
                              // STATUS
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InfoContainer(
                                  info: "Status",
                                  data: isOpen ? "Dibuka" : "Ditutup",
                                  dataStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // DURASI ABSENSI
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InfoContainer(
                                  info: "Durasi Absensi",
                                  data: '$duration Menit',
                                ),
                              ),
                              const SizedBox(height: 8),
                              // JAM BUKA ABSENSI
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InfoContainer(
                                  info: "Jam Buka Absensi",
                                  data: openedTime.displayHourMinute2,
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
                              // JUMLAH MAHASISWA
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InfoContainer(
                                  info: "Jumlah Mahasiswa",
                                  data:
                                      '${state.sessionData["sessionData"].totalStudent}',
                                ),
                              ),
                              const SizedBox(height: 8),
                              // JUMLAH KEHADIRAN
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InfoContainer(
                                  info: "Jumlah Kehadiran",
                                  data:
                                      '${state.sessionData["sessionData"].totalPresent}',
                                ),
                              ),
                              const SizedBox(height: 8),
                              // JUMLAH TIDAK HADIR
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InfoContainer(
                                  info: "Jumlah Tidak Hadir",
                                  data:
                                      '${state.sessionData["sessionData"].totalNotPresent}',
                                  dataStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: ColorPalettes.error,
                                          fontWeight: FontWeight.w600),
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
                              // AKTIFKAN LOKASI
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: InfoContainer(
                                  info: "Aktifkan Lokasi",
                                  data: isGeofence ? "Ya" : "Tidak",
                                  dataStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: ColorPalettes.success,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  "Daftar Mahasiswa",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: MyDelegate(
                            TabBar(
                              indicator: const UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    color: ColorPalettes.primary, width: 3),
                                insets: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                              labelColor: ColorPalettes.primary,
                              unselectedLabelStyle:
                                  Theme.of(context).textTheme.bodyText2,
                              unselectedLabelColor: ColorPalettes.dark70,
                              tabs: const [
                                Tab(
                                  text: "Hadir",
                                ),
                                Tab(
                                  text: "Tidak Hadir",
                                ),
                              ],
                            ),
                          ),
                          floating: true,
                          pinned: true,
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: presentList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorPalettes.whiteGray),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              child: AttendanceContainer(
                                studentName: presentList[index].studentName,
                                npm: presentList[index].npm,
                                deviceNumber: presentList[index].deviceCode,
                                isPresent: true,
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: notPresentList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorPalettes.whiteGray),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              child: AttendanceContainer(
                                studentName: notPresentList[index].studentName,
                                npm: notPresentList[index].npm,
                                deviceNumber:notPresentList[index].deviceCode,
                                isPresent: false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}

class AttendanceContainer extends StatelessWidget {
  final String studentName;
  final String deviceNumber;
  final String npm;
  final bool isPresent;
  const AttendanceContainer({
    Key? key,
    required this.studentName,
    required this.deviceNumber,
    required this.isPresent,
    required this.npm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isPresent ? Icons.check_circle : Icons.cancel,
          color: isPresent ? ColorPalettes.success : ColorPalettes.lightRed,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$studentName - $npm',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text('No. Device: $deviceNumber'),
            ],
          ),
        ),
      ],
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class InfoContainer extends StatelessWidget {
  final String info;
  final String data;
  final TextStyle? dataStyle;
  const InfoContainer({
    Key? key,
    required this.info,
    required this.data,
    this.dataStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(info),
        const Spacer(),
        Text(
          data,
          style: dataStyle,
        ),
      ],
    );
  }
}
