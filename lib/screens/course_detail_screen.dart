import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;

    return Scaffold(
      appBar: SecondaryAppbar(
        title: course.title,
        padding: EdgeInsets.zero,
      ),
      body: BlocProvider<CoursesBloc>(
        create: (_) {
          final repository = RepositoryProvider.of<CoursesRepository>(context);
          return CoursesBloc(repository)..add(FetchCourseClasses(course.id));
        },
        child: SubsConsumer<CoursesBloc, CoursesState>(
          builder: (context, state) {
            if (state is ClassesLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.listClasses.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SubsListTile(
                            title: state.listClasses[index].title,
                            titleWeight: FontWeight.normal,
                            isActive: true,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.classDetail,
                                arguments: {
                                  'class_data': state.listClasses[index],
                                  'course_name': course.title,
                                },
                              );
                            },
                            actionButtons: const [
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorPalettes.dark50,
                                size: 14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularLoading());
            }
          },
        ),
      ),
    );
  }
}
