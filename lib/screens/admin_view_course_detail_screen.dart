import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subscribeme_mobile/blocs/classes/classes_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/blocs/events/events_bloc.dart';
import 'package:subscribeme_mobile/commons/arguments/course_detail.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/resources/icons.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/repositories/classes_repository.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/repositories/events_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_alert_dialog.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_floating_action_button.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class AdminViewCourseDetail extends StatefulWidget {
  const AdminViewCourseDetail({Key? key}) : super(key: key);

  @override
  State<AdminViewCourseDetail> createState() => _AdminViewCourseDetailState();
}

class _AdminViewCourseDetailState extends State<AdminViewCourseDetail> {
  int? selectedFilterId;
  bool firstInitiate = true;

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;
    late CourseDetail courseDetail;

    return Scaffold(
      appBar: SecondaryAppbar(
        title: "Daftar Event",
        subTitle: course.title,
        padding: const EdgeInsets.only(top: 8.0),
      ),
      floatingActionButton: SubsFloatingActionButton(
        label: '+Event Tugas',
        onTap: () => Navigator.of(context)
            .pushNamed(Routes.addEventDetail, arguments: courseDetail),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<CoursesBloc>(
            create: (_) {
              final repository =
                  RepositoryProvider.of<CoursesRepository>(context);
              return CoursesBloc(repository)
                ..add(FetchCourseClasses(course.id));
            },
          ),
          BlocProvider<ClassesBloc>(
            create: (_) {
              final repository =
                  RepositoryProvider.of<ClassesRepository>(context);
              return ClassesBloc(repository);
            },
          ),
          BlocProvider<EventsBloc>(
            create: (_) {
              final repository =
                  RepositoryProvider.of<EventsRepository>(context);
              return EventsBloc(repository);
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 16.0),
                    SubsConsumer<CoursesBloc, CoursesState>(
                      builder: (context, state) {
                        if (state is ClassesLoaded) {
                          // Assign the courseDetail variable (preparation)
                          // if the user wants to add new event.
                          courseDetail = CourseDetail(
                            courseTitle: course.title,
                            courseId: course.id,
                            listClasses: state.listClasses,
                          );
                          if (firstInitiate) {
                            // Initiate the first filtered class is A.
                            final firstClassId = state.listClasses[0].id;
                            selectedFilterId = firstClassId;
                            BlocProvider.of<ClassesBloc>(context)
                                .add(FetchClassEvents(firstClassId));
                            firstInitiate = false;
                          }
                          return _buildFilterButtons(context, state);
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: SubsConsumer<ClassesBloc, ClassesState>(
                  builder: (context, classState) {
                    if (classState is FetchEventsSuccess) {
                      return SubsConsumer<EventsBloc, EventsState>(
                        listener: (context, eventState) {
                          if (eventState is DeleteEventSuccess) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.adminCourseDetail,
                              (route) =>
                                  route.settings.name ==
                                  Routes.adminViewCourses,
                              arguments: course,
                            );
                            SubsFlushbar.showSuccess(
                                context, 'Event berhasil dihapus!');
                          } else if (eventState is DeleteEventFailed) {
                            Navigator.of(context).pop();
                            SubsFlushbar.showFailed(context,
                                'Event gagal dihapus, tolong coba lagi!');
                          }
                        },
                        builder: (context, eventState) {
                          return _buildEventsList(classState, course);
                        },
                      );
                    } else {
                      return const ListShimmer(itemHeight: 64.0);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildFilterButtons(BuildContext context, ClassesLoaded state) {
    return SizedBox(
      width: getScreenSize(context).width,
      height: 25.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.listClasses.length,
        itemBuilder: (context, index) {
          var first = false;
          var last = false;
          if (index == 0) {
            first = true;
          } else if (index == state.listClasses.length - 1) {
            last = true;
          }
          return FilterButton(
            isSelected: selectedFilterId == state.listClasses[index].id,
            label: state.listClasses[index].title,
            first: first,
            last: last,
            onPress: () {
              setState(
                () {
                  selectedFilterId = state.listClasses[index].id;
                },
              );
              BlocProvider.of<ClassesBloc>(context).add(
                FetchClassEvents(state.listClasses[index].id),
              );
            },
          );
        },
      ),
    );
  }

  ListView _buildEventsList(FetchEventsSuccess state, Course course) {
    return ListView.builder(
      itemCount: state.listEvents.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SubsListTile(
          title: state.listEvents[index].title,
          secondLine: course.title,
          thirdLine: state.listEvents[index].deadlineTime.displayDeadline,
          actionButtons: [
            SvgPicture.asset(SubsIcons.penciSlash),
            const SizedBox(width: 16.0),
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => SubsAlertDialog(
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return const Center(child: CircularLoading());
                        });
                    BlocProvider.of<EventsBloc>(context)
                        .add(DeleteEvent(state.listEvents[index].id));
                  },
                  textSpan: [
                    TextSpan(
                      text: 'Apakah Kamu Yakin Ingin Menghapus Event ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: '${state.listEvents[index].title} ',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorPalettes.error,
                          ),
                    ),
                    TextSpan(
                      text: 'dari Mata Kuliah ${course.title}?',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              child: SvgPicture.asset(SubsIcons.trash),
            ),
          ],
          isActive: true,
          onTap: () {},
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final bool first;
  final bool last;
  final VoidCallback onPress;
  const FilterButton({
    Key? key,
    required this.isSelected,
    required this.label,
    required this.first,
    required this.last,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: first ? 0.0 : 8.0,
        right: last ? 0.0 : 8.0,
      ),
      child: TextButton(
        onPressed: onPress,
        style: Theme.of(context).textButtonTheme.style!.copyWith(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8.0)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              minimumSize: MaterialStateProperty.all(
                const Size(0.0, 25.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(isSelected
                  ? ColorPalettes.primary
                  : ColorPalettes.disabledButton),
            ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
