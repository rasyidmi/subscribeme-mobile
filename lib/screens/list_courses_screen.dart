import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course_scele.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class ListCoursesScreen extends StatefulWidget {
  const ListCoursesScreen({Key? key}) : super(key: key);

  @override
  State<ListCoursesScreen> createState() => _ListCoursesScreenState();
}

class _ListCoursesScreenState extends State<ListCoursesScreen> {
  List<CourseScele>? _listCourses;
  List<CourseScele>? _searchedData;
  bool _firstLoad = true;
  String _searchValue = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoursesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<CoursesRepository>(context);
        return CoursesBloc(repository)..add(FetchSubscribedCourses());
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SubsConsumer<CoursesBloc, CoursesState>(
            builder: (context, state) {
              if (state is FetchSubscribedCoursesSuccess) {
                _listCourses = state.courses;
                if (_firstLoad) {
                  _searchedData = _listCourses;
                  _firstLoad = false;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 38),
                    SubsSearchBar(
                      hintText: "Cari kelas...",
                      onChanged: _onSearchChanged,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: const BoxDecoration(
                          color: ColorPalettes.lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Pilih mata kuliah yang hanya kamu ambil pada semester ini.",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed(Routes.subscribeCourse),
                            child: Text(
                              "Pilih Matkul",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: ColorPalettes.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_searchValue.isNotEmpty)
                      const Text("Hasil pencarian..."),
                    if (_searchValue.isNotEmpty) const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _searchedData!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: SubsListTile(
                            title: _searchedData![index].name,
                            titleWeight: FontWeight.normal,
                            onTap: () => Navigator.of(context).pushNamed(
                                Routes.courseDetail,
                                arguments: _searchedData![index]),
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
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              } else if (state is FetchSubscribedCoursesFailed &&
                  state.status == ResponseStatus.saveDataDisabled) {
                return Column(
                  children: [
                    SizedBox(height: getScreenSize(context).height * 0.1),
                    Image.asset(
                      SubsImages.salySorry,
                      height: getScreenSize(context).height * 0.4,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else {
                return const ListShimmer(itemHeight: 48);
              }
            },
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    _searchValue = value;
    _searchedData = [];
    for (var data in _listCourses!) {
      if (data.name.toLowerCase().contains((value.toLowerCase()))) {
        _searchedData!.add(data);
      }
    }
    setState(() {});
  }
}
