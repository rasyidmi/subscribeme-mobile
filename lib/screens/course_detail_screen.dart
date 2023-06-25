import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/blocs/events/events_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course_scele.dart';
import 'package:subscribeme_mobile/models/event.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/repositories/events_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/services/date_time_picker.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_bottomsheet.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_secondary_button.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as CourseScele;

    return BlocProvider<CoursesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<CoursesRepository>(context);
        return CoursesBloc(repository)..add(FetchCourseEvents(course.id));
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              CustomAppBar(courseName: course.name),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Tugas Kelas Ini",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: SubsSearchBar(
                          hintText: "Cari tugas di kelas ini...",
                        ),
                      ),
                      SubsConsumer<CoursesBloc, CoursesState>(
                        builder: (context, state) {
                          if (state is FetchCourseEventsSuccess) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.events.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16, index == 0 ? 18 : 6, 16, 6),
                                  child: SubsListTile(
                                    title: state.events[index].name,
                                    onTap: !state.events[index].isDone &&
                                            state.events[index].remainingDays >=
                                                0
                                        ? () => showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) =>
                                                  StatefulBottomSheet(
                                                event: state.events[index],
                                                course: course,
                                              ),
                                            )
                                        : null,
                                    isActive: !state.events[index].isDone &&
                                        state.events[index].remainingDays >= 0,
                                    secondLine: state.events[index].deadlineTime
                                        .displayDeadline,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            );
                          } else {
                            return const ListShimmer(itemHeight: 48);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatefulBottomSheet extends StatefulWidget {
  final Event event;
  final CourseScele course;

  const StatefulBottomSheet({
    Key? key,
    required this.event,
    required this.course,
  }) : super(key: key);

  @override
  State<StatefulBottomSheet> createState() => _StatefulBottomSheetState();
}

class _StatefulBottomSheetState extends State<StatefulBottomSheet> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<EventsRepository>(context);
        return EventsBloc(repository);
      },
      child: SubsConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is SetReminderLoading) {
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
          } else if (state is SetReminderSuccess) {
            Navigator.popUntil(
                context, (route) => route.settings.name == Routes.courseDetail);
            SubsFlushbar.showSuccess(context, "Reminder berhasil dibuat!");
          } else if (state is SetReminderFailed) {
            Navigator.pop(context);
            SubsFlushbar.showSuccess(context, "Reminder gagal dibuat!");
          }
        },
        builder: (context, state) {
          return SubsBottomsheet(
            content: [
              const Spacer(),
              Text(
                widget.event.name,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: ColorPalettes.primary),
              ),
              const SizedBox(height: 10),
              Text(
                'Deadline: ${widget.event.deadlineTime.toDayMonthYearFormat}',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: ColorPalettes.lightRed, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(widget.course.name,
                  style: Theme.of(context).textTheme.subtitle2),
              const SizedBox(height: 20),
              // BELL
              Row(
                children: [
                  const Icon(
                    Icons.notifications,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Ingatkan Aku Pada?",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // DATE PICKER
              InkWell(
                onTap: () async {
                  selectedDate = await showDateTimePicker(
                        context: context,
                        lastDate: widget.event.deadlineTime
                            .add(const Duration(days: 1)),
                      ) ??
                      selectedDate;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: ColorPalettes.whiteGray),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        selectedDate != null
                            ? selectedDate!.getDateWithTime
                            : "Pilih Tanggal Pengingat",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: selectedDate != null
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
              const SizedBox(height: 20),
              // DIVIDER
              Row(
                children: [
                  const _SmallDivider(),
                  const SizedBox(width: 12),
                  Text(
                    "Atau".toLowerCase(),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(width: 12),
                  const _SmallDivider(),
                ],
              ),
              const SizedBox(height: 8),
              // CHECKBOX
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: widget.event.isDone,
                      activeColor: ColorPalettes.primary,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Tandai Sudah Selesai",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Spacer(),
              // BUTTONS
              Row(
                children: [
                  Expanded(
                    child: SubsSecondaryButton(
                      buttonText: "Batalkan",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SubsRoundedButton(
                      buttonText: "Simpan Perubahan",
                      onTap: isFormComplete
                          ? () {
                              BlocProvider.of<EventsBloc>(context).add(
                                  SetReminder(widget.event, selectedDate!));
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  bool get isFormComplete {
    return selectedDate != null;
  }
}

class CustomAppBar extends StatelessWidget {
  final String courseName;
  const CustomAppBar({
    Key? key,
    required this.courseName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16.0),
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            border: Border.all(color: ColorPalettes.whiteGray),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 16.0,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_outlined),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            courseName,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: ColorPalettes.primary),
          ),
        )
      ],
    );
  }
}

class _SmallDivider extends StatelessWidget {
  const _SmallDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        decoration: const BoxDecoration(
          color: ColorPalettes.whiteGray,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }
}
