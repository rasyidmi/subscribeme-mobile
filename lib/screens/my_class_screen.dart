import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/classes/classes_bloc.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/repositories/classes_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/list_courses/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class MyClassScreen extends StatefulWidget {
  final PageController pageController;
  const MyClassScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<MyClassScreen> createState() => _MyClassScreenState();
}

class _MyClassScreenState extends State<MyClassScreen> {
  List<Class>? _listClasses;
  List<Class>? _searchedData;
  bool _firstLoad = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClassesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<ClassesRepository>(context);
        return ClassesBloc(repository)..add(FetchUserClass());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 38),
            SubsSearchBar(
              hintText: LocaleKeys.list_class_screen_search_class.tr(),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 21),
            Container(
              decoration: const BoxDecoration(
                  color: ColorPalettes.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.list_class_screen_info.tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 21),
            BlocBuilder<ClassesBloc, ClassesState>(
              builder: (context, state) {
                if (state is FetchUserClassSuccess) {
                  _listClasses = state.classes;
                  if ( _firstLoad) {
                    _searchedData = _listClasses;
                    _firstLoad = false;
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _searchedData!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SubsListTile(
                            title:
                                '${_searchedData![index].courseCode} - ${_searchedData![index].courseName}',
                            actionButtons: const [
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorPalettes.dark50,
                                size: 14.0,
                              ),
                            ],
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.classDetail, arguments: _searchedData![index]);
                            },
                            isActive: true,
                            titleWeight: FontWeight.normal,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: ListShimmer(itemHeight: 48),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    _searchedData = [];
    for (var data in _listClasses!) {
      if (data.courseName.toLowerCase().contains((value.toLowerCase()))) {
        _searchedData!.add(data);
      }
      setState(() {});
    }
  }
}
