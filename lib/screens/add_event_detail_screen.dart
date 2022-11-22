import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/events/events_bloc.dart';
import 'package:subscribeme_mobile/commons/arguments/course_detail.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/extensions/string_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/repositories/events_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/admin_menu/class/time_form_container.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_text_field.dart';

class AddEventDetailScreen extends StatefulWidget {
  const AddEventDetailScreen({Key? key}) : super(key: key);

  @override
  State<AddEventDetailScreen> createState() => _AddEventDetailScreenState();
}

class _AddEventDetailScreenState extends State<AddEventDetailScreen> {
  TextEditingController eventNameController = TextEditingController();
  List<int> selectedClass = [];
  DateTime? selectedDay;
  TimeOfDay? selectedTime;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final courseDetail =
        ModalRoute.of(context)!.settings.arguments as CourseDetail;

    return BlocProvider<EventsBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<EventsRepository>(context);
        return EventsBloc(repository);
      },
      child: Scaffold(
        appBar: const SecondaryAppbar(title: 'Tambah Event'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubsTextField(
                      label: 'Nama Tugas',
                      hintText: 'Sprint Retrospective',
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      inputFormatters: [LengthLimitingTextInputFormatter(40)],
                      controller: eventNameController,
                      onChanged: (_) {
                        // To update the state of the save button when
                        // user change input
                        setState(() {});
                      },
                    ),
                    SubsTextField(
                      label: 'Mata Kuliah',
                      enabled: false,
                      hintText: courseDetail.courseTitle,
                      // controller: courseNameController,
                    ),
                    ..._buildFormSpacing('Tambah Kelas'),
                    _buildClassesButton(context, courseDetail),
                    ..._buildFormSpacing('Tanggal Pengumpulan'),
                    _buildDatePicker(context),
                    ..._buildFormSpacing('Jam Pengumpulan'),
                    _buildTimePicker(context),
                    const Spacer(),
                    _buildButton(courseDetail),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormSpacing(String label) {
    return [
      const SizedBox(height: 24.0),
      Text(label),
      const SizedBox(height: 8.0),
    ];
  }

  SizedBox _buildClassesButton(
      BuildContext context, CourseDetail courseDetail) {
    return SizedBox(
      width: getScreenSize(context).width,
      height: 25.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courseDetail.listClasses.length,
        itemBuilder: (context, index) {
          var first = false;
          var last = false;
          if (index == 0) {
            first = true;
          } else if (index == courseDetail.listClasses.length - 1) {
            last = true;
          }
          return SelectClassButton(
            label: courseDetail.listClasses[index].title[6],
            first: first,
            last: last,
            isSelected:
                selectedClass.contains(courseDetail.listClasses[index].id),
            onTap: () {
              final int id = courseDetail.listClasses[index].id;
              if (selectedClass.contains(id)) {
                selectedClass.remove(id);
              } else {
                selectedClass.add(id);
              }
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TimeFormContainer(
      onTap: () {
        showDatePicker(
          context: context,
          // Set the minimum deadline date is D+2 from now
          initialDate: DateTime.now().add(
            const Duration(days: 2),
          ),
          firstDate: DateTime.now().add(
            const Duration(days: 2),
          ),
          lastDate: DateTime.now().add(
            const Duration(days: 30 * 6),
          ),
          builder: (context, child) {
            return _buildTimeFormTheme(context, child);
          },
        ).then(
          (value) {
            if (value != null) {
              setState(() {
                selectedDay = value;
              });
            }
          },
        );
      },
      icon: Icons.calendar_today,
      text: Text(
        selectedDay == null
            ? 'Pilih Tanggal Pengumpulan'
            : selectedDay!.toDayMonthYearFormat,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: selectedDay == null
                ? Colors.black.withOpacity(0.3)
                : ColorPalettes.dark70),
      ),
    );
  }

  Theme _buildTimeFormTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
            primary: ColorPalettes.primary // header background color
            ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: ColorPalettes.primary // button text color
              ),
        ),
      ),
      child: child!,
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return TimeFormContainer(
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: const TimeOfDay(
            hour: 0,
            minute: 0,
          ),
          builder: (context, child) {
            return _buildTimeFormTheme(context, child);
          },
        ).then(
          (value) {
            setState(() {
              if (value != null) {
                selectedTime = value;
              }
            });
          },
        );
      },
      icon: Icons.alarm,
      text: Text(
        selectedTime == null
            ? 'Pilih Jam Pengumpulan (WIB)'
            : selectedTime!.to24HourFormat + ' WIB',
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: selectedTime == null
                ? Colors.black.withOpacity(0.3)
                : ColorPalettes.dark70),
      ),
    );
  }

  SafeArea _buildButton(CourseDetail courseDetail) {
    return SafeArea(
      child: SubsConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is CreateEventLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is CreateEventSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.adminCourseDetail,
              (route) => route.settings.name == Routes.adminViewCourses,
              arguments: Course(
                id: courseDetail.courseId,
                title: courseDetail.courseTitle,
                major: '',
                term: 0,
              ),
            );
            SubsFlushbar.showSuccess(
              context,
              'Event berhasil terbuat',
            );
          } else if (state is CreateEventFailed) {
            setState(() {
              isLoading = false;
            });
            SubsFlushbar.showFailed(
              context,
              'Terjadi kesalahan, silahkan coba lagi!',
            );
          }
        },
        builder: (context, state) {
          return SubsRoundedButton(
            buttonText: 'Simpan Event',
            isLoading: isLoading,
            onTap: _isFormFilled
                ? () {
                    BlocProvider.of<EventsBloc>(context)
                        .add(CreateEvent(_convertData(
                      courseDetail.courseTitle,
                      courseDetail.courseId,
                    )));
                  }
                : null,
          );
        },
      ),
    );
  }

  Map<String, dynamic> _convertData(String courseName, int courseId) {
    return {
      'title': eventNameController.text.toTitleCase,
      'deadline_date': _converDeadlineDate,
      'classes_id': selectedClass,
      'subject_id': courseId,
      'subject_name': courseName,
    };
  }

  String get _converDeadlineDate {
    return selectedDay!
            .add(Duration(
              hours: selectedTime!.hour,
              minutes: selectedTime!.minute,
            ))
            .toIso8601String() +
        '+07:00';
  }

  bool get _isFormFilled {
    return eventNameController.text.isNotEmpty &&
        selectedClass.isNotEmpty &&
        selectedDay != null &&
        selectedTime != null;
  }
}

class SelectClassButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final String label;
  final bool first;
  final bool last;
  const SelectClassButton({
    Key? key,
    required this.label,
    required this.first,
    required this.last,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: first ? 0.0 : 8.0,
        right: last ? 0.0 : 8.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 25.0,
          width: 25.0,
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected
                    ? ColorPalettes.primary
                    : ColorPalettes.whiteGray),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: isSelected
                        ? ColorPalettes.primary
                        : Colors.black.withOpacity(0.2),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
