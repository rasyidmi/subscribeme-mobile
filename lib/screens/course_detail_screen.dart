import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course_scele.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/widgets/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/stateful_bottom_sheet.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

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
                                                courseName: course.name,
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