// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
// import 'package:subscribeme_mobile/commons/constants/sizes.dart';
// import 'package:subscribeme_mobile/commons/resources/icons.dart';
// import 'package:subscribeme_mobile/commons/resources/images.dart';
// import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
// import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
// import 'package:subscribeme_mobile/models/course.dart';
// import 'package:subscribeme_mobile/repositories/courses_repository.dart';
// import 'package:subscribeme_mobile/routes.dart';
// import 'package:subscribeme_mobile/widgets/circular_loading.dart';
// import 'package:subscribeme_mobile/widgets/list_courses/custom_search_bar.dart';
// import 'package:subscribeme_mobile/widgets/list_courses/search_result_container.dart';
// import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
// import 'package:subscribeme_mobile/widgets/shimmer/list_course_shimmer.dart';
// import 'package:subscribeme_mobile/widgets/subs_alert_dialog.dart';
// import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
// import 'package:subscribeme_mobile/widgets/subs_floating_action_button.dart';
// import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
// import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

// class AdminViewCourses extends StatefulWidget {
//   const AdminViewCourses({Key? key}) : super(key: key);

//   @override
//   State<AdminViewCourses> createState() => _AdminViewCoursesState();
// }

// class _AdminViewCoursesState extends State<AdminViewCourses> {
//   List<Course> _listCourses = [];
//   List<Course>? _searchedData;
//   String _searchValue = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: SecondaryAppbar(
//           title: LocaleKeys.admin_view_courses_screen_title.tr()),
//       body: BlocProvider<CoursesBloc>(
//         create: (_) {
//           final repository = RepositoryProvider.of<CoursesRepository>(context);
//           return CoursesBloc(repository)..add(FetchCourses());
//         },
//         child: SafeArea(
//           minimum: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             children: [
//               Container(height: 16.0, color: ColorPalettes.white),
//               ColoredBox(
//                 color: ColorPalettes.white,
//                 child: SubsSearchBar(
//                   hintText: LocaleKeys.list_course_screen_search_course.tr(),
//                   onChanged: _onSearchChanged,
//                 ),
//               ),
//               SubsConsumer<CoursesBloc, CoursesState>(
//                 listener: ((context, state) {
//                   if (state is DeleteCourseSuccess) {
//                     Navigator.of(context).pushNamedAndRemoveUntil(
//                         Routes.adminViewCourses,
//                         (route) => route.settings.name == Routes.home);
//                     SubsFlushbar.showSuccess(
//                         context,
//                         LocaleKeys.admin_view_courses_screen_success_delete
//                             .tr());
//                   } else if (state is DeleteCourseFailed) {
//                     Navigator.of(context).pop();
//                     SubsFlushbar.showFailed(
//                         context,
//                         LocaleKeys.admin_view_courses_screen_failed_delete
//                             .tr());
//                   }
//                 }),
//                 buildWhen: (previous, current) {
//                   return current is LoadCoursesSuccess ||
//                       current is LoadCoursesLoading ||
//                       current is LoadClassesFailed;
//                 },
//                 builder: (context, state) {
//                   if (state is LoadCoursesSuccess && _searchValue.isEmpty) {
//                     _listCourses = state.listCourses;
//                     _searchedData = _listCourses;
//                     String previousLetter = '';
//                     return Expanded(
//                       child: ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: _searchedData!.length,
//                         itemBuilder: (_, index) {
//                           // Check the first letter of the string is not same with
//                           // the previous one
//                           if (previousLetter !=
//                               _searchedData![index].title[0]) {
//                             previousLetter = _searchedData![index].title[0];
//                             return _buildListWithIndex(
//                                 previousLetter, context, index);
//                           } else {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 8.0),
//                               child: _buildListTile(index, context),
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   } else if (_searchValue.isNotEmpty) {
//                     // User is searching the data
//                     if (_searchedData!.isEmpty) {
//                       return SearchResultContainer(
//                           body: Expanded(
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 SubsImages.salySorry,
//                                 height: getScreenSize(context).height / 4,
//                               ),
//                               Text(
//                                 LocaleKeys.data_not_found.tr(),
//                                 textAlign: TextAlign.center,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(color: ColorPalettes.primary),
//                               ),
//                               const SizedBox(height: 8.0),
//                               Text(
//                                 LocaleKeys
//                                     .list_course_screen_find_another_course
//                                     .tr(),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ));
//                     }
//                     return SearchResultContainer(
//                       body: Expanded(
//                         child: ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           itemCount: _searchedData!.length,
//                           itemBuilder: (_, index) => Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: _buildListTile(index, context),
//                           ),
//                         ),
//                       ),
//                     );
//                   } else if (state is LoadCoursesFailed) {
//                     return Center(child: Text(LocaleKeys.load_failed.tr()));
//                   } else {
//                     return const Expanded(
//                       child: ListCourseShimmer(),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: SubsFloatingActionButton(
//         label: '+${LocaleKeys.course.tr()}',
//         onTap: () => Navigator.of(context).pushNamed(Routes.addCourse),
//       ),
//     );
//   }

//   SubsListTile _buildListTile(int index, BuildContext context) {
//     return SubsListTile(
//       title: _searchedData![index].title,
//       secondLine: _searchedData![index].major,
//       thirdLine: '${LocaleKeys.add_course_screen_term.tr()} ${_searchedData![index].term}',
//       onTap: () => _navigateToCourseDetail(index),
//       isActive: true,
//       actionButtons: [
//         SvgPicture.asset(SubsIcons.penciSlash),
//         const SizedBox(width: 16.0),
//         InkWell(
//           onTap: () => showDialog(
//             context: context,
//             builder: (_) => SubsAlertDialog(
//               onTap: () {
//                 Navigator.of(context).pop();
//                 showDialog(
//                     context: context,
//                     builder: (_) {
//                       return const Center(child: CircularLoading());
//                     });
//                 BlocProvider.of<CoursesBloc>(context)
//                     .add(DeleteCourse(_searchedData![index].id));
//               },
//               textSpan: [
//                 TextSpan(
//                   text: '${LocaleKeys.admin_view_courses_screen_are_you_sure.tr()} ',
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//                 TextSpan(
//                   text: '${_searchedData![index].title}?',
//                   style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: ColorPalettes.error,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           child: SvgPicture.asset(SubsIcons.trash),
//         ),
//       ],
//     );
//   }

//   void _onSearchChanged(String value) {
//     _searchValue = value;
//     _searchedData = [];
//     for (var course in _listCourses) {
//       if (course.title.toLowerCase().contains((value.toLowerCase()))) {
//         _searchedData!.add(course);
//       }
//       setState(() {});
//     }
//   }

//   Column _buildListWithIndex(
//       String previousLetter, BuildContext context, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 16.0),
//         Text(
//           previousLetter,
//           style: Theme.of(context).textTheme.subtitle1!.copyWith(
//                 color: ColorPalettes.primary,
//               ),
//         ),
//         const Divider(color: ColorPalettes.whiteGray),
//         const SizedBox(height: 8.0),
//         _buildListTile(index, context),
//         const SizedBox(height: 8.0),
//       ],
//     );
//   }

//   void _navigateToCourseDetail(int index) {
//     Navigator.of(context).pushNamed(
//       Routes.adminCourseDetail,
//       arguments: _searchedData![index],
//     );
//   }
// }
