import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/attendance/attendance_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/repositories/attendance_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/bottom_button_container.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_text_field.dart';

class AddAttendanceScreen extends StatefulWidget {
  const AddAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AddAttendanceScreen> createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  bool isGeo = false;
  DateTime? attendanceDate;
  TimeOfDay? time;
  int? duration;
  int? radius;

  @override
  Widget build(BuildContext context) {
    final classCode = ModalRoute.of(context)!.settings.arguments as String;
    log(classCode);

    return BlocProvider<AttendanceBloc>(
      lazy: false,
      create: (_) {
        final repository = RepositoryProvider.of<AttendanceRepository>(context);
        return AttendanceBloc(repository);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const SecondaryAppbar(
          title: "Absensi Mahasiswa",
          subTitle: "Ubah/Tambah Informasi",
        ),
        bottomSheet: Builder(
          builder: (context) {
            return BottomContainer(
              child: SubsRoundedButton(
                buttonText: "Simpan Mata Kuliah Terpilih",
                onTap: isFormComplete
                    ? () {
                        // context.read<AttendanceBloc>().add(CreateAttendance(
                        //       isGeofence: isGeo,
                        //       classCode: classCode,
                        //       duration: duration!,
                        //       startTime: _combineDateAndTime(),
                        //     ));
                        BlocProvider.of<AttendanceBloc>(context)
                            .add(CreateAttendance(
                          isGeofence: isGeo,
                          classCode: classCode,
                          duration: duration!,
                          startTime: _combineDateAndTime(),
                        ));
                      }
                    : null,
              ),
            );
          },
        ),
        body: SubsConsumer<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is CreateAttendanceLoading) {
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
            } else if (state is CreateAttendanceSuccess) {
              Navigator.of(context)
                  .popUntil((route) => route.settings.name == Routes.lecture);
              SubsFlushbar.showSuccess(context, "Slot absensi berhasil dibuat");
            } else if (state is CreateAttendanceFailed) {
              Navigator.of(context)
                  .popUntil((route) => route.settings.name == Routes.lecture);
              SubsFlushbar.showFailed(context, "Slot absensi gagal dibuat");
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "Tanggal Buka Absensi",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _showDatePicker(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: ColorPalettes.whiteGray),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text(
                            attendanceDate != null
                                ? attendanceDate!.getDate
                                : "Pilih tanggal buka absensi",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: attendanceDate != null
                                        ? ColorPalettes.dark70
                                        : ColorPalettes.gray),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.date_range,
                            color: ColorPalettes.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Waktu Buka Absensi",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _showTimePicker(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: ColorPalettes.whiteGray),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text(
                            time != null
                                ? time!.to24HourFormat
                                : "Pilih waktu buka absensi",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: time != null
                                        ? ColorPalettes.dark70
                                        : ColorPalettes.gray),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.schedule,
                            color: ColorPalettes.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Durasi Absensi (Menit)",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SubsTextField(
                    hintText: "Tentukan durasi absensi dalam menit",
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        duration = int.tryParse(value);
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Aktifkan Lokasi Mahasiswa",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: isGeo,
                        activeColor: ColorPalettes.primary,
                        onChanged: (bool value) {
                          setState(() {
                            isGeo = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  isGeo
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Radius Lokasi (Meter)",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 12),
                  isGeo
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SubsTextField(
                            hintText: "Tentukan radius lokasi dalam meter",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              setState(() {
                                radius = int.tryParse(value);
                              });
                            },
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    attendanceDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorPalettes.primary, // header background color
              onPrimary: ColorPalettes.white, // header text color
              onSurface: ColorPalettes.primary, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorPalettes.primary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale("id", "ID"),
    );
    setState(() {});
  }

  void _showTimePicker(BuildContext context) async {
    time = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorPalettes.primary, // header background color
              onPrimary: ColorPalettes.white, // header text color
              onSurface: ColorPalettes.primary, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorPalettes.primary, // button text color
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              dialBackgroundColor: ColorPalettes.primary.withOpacity(0.1),
              hourMinuteColor: ColorPalettes.primary.withOpacity(0.1),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {});
  }

  DateTime _combineDateAndTime() {
    return attendanceDate!
        .add(Duration(hours: time!.hour, minutes: time!.minute));
  }

  bool get isFormComplete {
    return (!isGeo &&
            radius == null &&
            attendanceDate != null &&
            duration != null ||
        isGeo && radius != null && attendanceDate != null && duration != null);
  }
}
