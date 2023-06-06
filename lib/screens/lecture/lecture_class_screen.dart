import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/classes/classes_bloc.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/repositories/classes_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class LectureClassScreen extends StatefulWidget {
  const LectureClassScreen({Key? key}) : super(key: key);

  @override
  State<LectureClassScreen> createState() => _LectureClassScreenState();
}

class _LectureClassScreenState extends State<LectureClassScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClassesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<ClassesRepository>(context);
        return ClassesBloc(repository)..add(FetchLectureClass());
      },
      child: SubsConsumer<ClassesBloc, ClassesState>(
        builder: (context, state) {
          if (state is FetchLectureClassSuccess) {
            String courseName = "";
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SubsSearchBar(hintText: "Cari mata kuliah..."),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.classes.length,
                      itemBuilder: (context, index) {
                        // If its the first class, create with course name.
                        if (courseName != state.classes[index].courseName) {
                          courseName = state.classes[index].courseName;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                state.classes[index].courseName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: SubsListTile(
                                  title: state.classes[index].name,
                                  actionButtons: const [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorPalettes.dark50,
                                      size: 14.0,
                                    ),
                                  ],
                                  onTap: () => Navigator.of(context).pushNamed(
                                      Routes.lectureClassDetail,
                                      arguments: state.classes[index]),
                                  isActive: true,
                                  titleWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: SubsListTile(
                            title: state.classes[index].name,
                            actionButtons: const [
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorPalettes.dark50,
                                size: 14.0,
                              ),
                            ],
                            onTap: () => Navigator.of(context).pushNamed(
                                Routes.lectureClassDetail,
                                arguments: state.classes[index]),
                            isActive: true,
                            titleWeight: FontWeight.normal,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
              child: ListShimmer(itemHeight: 48),
            );
          }
        },
      ),
    );
  }
}
