import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/bottom_button_container.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class SubscribeCourseScreen extends StatefulWidget {
  const SubscribeCourseScreen({Key? key}) : super(key: key);

  @override
  State<SubscribeCourseScreen> createState() => _SubscribeCourseScreenState();
}

class _SubscribeCourseScreenState extends State<SubscribeCourseScreen> {
  List<Course> _coursesData = [];
  final List<Course> _mutableCourse = [];
  bool _firstLoad = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoursesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<CoursesRepository>(context);
        return CoursesBloc(repository)..add(FetchUserCourses());
      },
      child: Scaffold(
        appBar: SecondaryAppbar(
            title: LocaleKeys.list_course_screen_choosen_course.tr()),
        body: SubsConsumer<CoursesBloc, CoursesState>(
          listener: (context, state) {
            if (state is SubscribeCourseLoading) {
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
            } else if (state is SubscribeCourseSuccess) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.main, (route) => false);
              SubsFlushbar.showSuccess(context, "Data berhasil disimpan");
            } else if (state is SubscribeCourseFailed) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.main, (route) => false);
              SubsFlushbar.showFailed(context, "Data gagal disimpan");
            }
          },
          builder: (context, state) {
            if (state is FetchUserCoursesSuccess && _firstLoad) {
              _coursesData = state.courses;
              for (var i = 0; i < _coursesData.length; i++) {
                final course = Course(
                  id: _coursesData[i].id,
                  name: _coursesData[i].name,
                  isSubscribe: _coursesData[i].isSubscribe,
                );
                _mutableCourse.add(course);
              }
              _firstLoad = false;
            }
            if (state is FetchUserCoursesSuccess) {
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _coursesData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(left: 8, right: 20),
                        margin:
                            EdgeInsets.fromLTRB(16, index == 0 ? 20 : 8, 16, 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: ColorPalettes.whiteGray),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _mutableCourse[index].isSubscribe,
                              onChanged: (newValue) {
                                setState(() {
                                  _mutableCourse[index].isSubscribe = newValue!;
                                });
                              },
                              activeColor: ColorPalettes.lightRed,
                            ),
                            Expanded(
                              child: Text(_mutableCourse[index].name),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  BottomContainer(
                    child: SubsRoundedButton(
                      buttonText: "Simpan Mata Kuliah Terpilih",
                      onTap: () {
                        _subscribeCourse(context);
                      },
                    ),
                  )
                ],
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: ListShimmer(itemHeight: 64),
              );
            }
          },
        ),
      ),
    );
  }

  void _subscribeCourse(BuildContext context) {
    for (var i = 0; i < _coursesData.length; i++) {
      // Subscribe
      if (!_coursesData[i].isSubscribe &&
          _coursesData[i].isSubscribe != _mutableCourse[i].isSubscribe) {
        BlocProvider.of<CoursesBloc>(context)
            .add(SubscribeCourse(_coursesData[i]));
      }
    }
  }
}
