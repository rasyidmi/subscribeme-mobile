import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/list_courses/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/list_courses/search_result_container.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_course_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class ListCoursesScreen extends StatefulWidget {
  const ListCoursesScreen({Key? key}) : super(key: key);

  @override
  State<ListCoursesScreen> createState() => _ListCoursesScreenState();
}

class _ListCoursesScreenState extends State<ListCoursesScreen> {
  List<Course> _listCourses = [];
  List<Course>? _searchedData;
  String _searchValue = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoursesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<CoursesRepository>(context);
        return CoursesBloc(repository)..add(FetchCourses());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(height: 16.0, color: ColorPalettes.white),
            ColoredBox(
              color: ColorPalettes.white,
              child: SubsSearchBar(
                hintText: 'cari mata kuliah ...',
                onChanged: _onSearchChanged,
              ),
            ),
            SubsConsumer<CoursesBloc, CoursesState>(
              builder: (context, state) {
                if (state is LoadCoursesSuccess && _searchValue.isEmpty) {
                  _listCourses = state.listCourses;
                  _searchedData = _listCourses;
                  String previousLetter = '';
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _searchedData!.length,
                      itemBuilder: (context, index) {
                        // Check the first letter of the string is not same with
                        // the previous one
                        if (previousLetter != _searchedData![index].title[0]) {
                          previousLetter = _searchedData![index].title[0];
                          return _buildListWithIndex(
                              previousLetter, context, index);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SubsListTile(
                              title: _searchedData![index].title,
                              titleWeight: FontWeight.normal,
                              onTap: () {
                                _navigateToCourseDetail(index);
                              },
                              isActive: true,
                              actionButtons: const [
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ColorPalettes.dark50,
                                  size: 14.0,
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else if (_searchValue.isNotEmpty) {
                  // User is searching the data
                  if (_searchedData!.isEmpty) {
                    return SearchResultContainer(
                        body: Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              SubsImages.salySorry,
                              height: getScreenSize(context).height / 4,
                            ),
                            Text(
                              "Data tidak ditemukan",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "silahkan cari dengan nama lain",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ));
                  }
                  return SearchResultContainer(
                    body: Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _searchedData!.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SubsListTile(
                            title: _searchedData![index].title,
                            titleWeight: FontWeight.normal,
                            onTap: () {
                              _navigateToCourseDetail(index);
                            },
                            isActive: true,
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
                  );
                } else if (state is LoadCoursesFailed) {
                  return const Center(child: Text('Load failed'));
                } else {
                  return const Expanded(
                    child: ListCourseShimmer(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCourseDetail(int index) {
    Navigator.of(context).pushNamed(
      Routes.courseDetail,
      arguments: _searchedData![index],
    );
  }

  void _onSearchChanged(String value) {
    _searchValue = value;
    _searchedData = [];
    for (var course in _listCourses) {
      if (course.title.toLowerCase().contains((value.toLowerCase()))) {
        _searchedData!.add(course);
      }
      setState(() {});
    }
  }

  Column _buildListWithIndex(
      String previousLetter, BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          previousLetter,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: ColorPalettes.primary,
              ),
        ),
        const Divider(color: ColorPalettes.whiteGray),
        const SizedBox(height: 8.0),
        SubsListTile(
          title: _listCourses[index].title,
          titleWeight: FontWeight.normal,
          onTap: () {
            _navigateToCourseDetail(index);
          },
          isActive: true,
          actionButtons: const [
            Icon(
              Icons.arrow_forward_ios,
              color: ColorPalettes.dark50,
              size: 14.0,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
