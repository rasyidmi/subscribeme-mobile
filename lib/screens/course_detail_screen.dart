import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/course_scele.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/widgets/custom_search_bar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_bottomsheet.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
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
                                    onTap: () => showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => SubsBottomsheet(
                                        content: [
                                          const Spacer(),
                                          Text(
                                            state.events[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                    color:
                                                        ColorPalettes.primary),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Deadline: ${state.events[index].deadlineTime.toDayMonthYearFormat}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        ColorPalettes.lightRed,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(course.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
                                          const SizedBox(height: 20),
                                          // BELL
                                          _buildBell(context),
                                          const SizedBox(height: 12),
                                          // DATE PICKER
                                          _buildDatePicker(context),
                                          const SizedBox(height: 20),
                                          // DIVIDER
                                          _buildDivider(),
                                          const SizedBox(height: 8),
                                          // CHECKBOX
                                          _buildCheckBox(context),
                                          const Spacer(),
                                          // BUTTONS
                                          _buildButtons(context)
                                        ],
                                      ),
                                    ),
                                    isActive: true,
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

  Row _buildBell(BuildContext context) {
    return Row(
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
    );
  }

  Container _buildDatePicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ColorPalettes.whiteGray),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(
            "Pilih Tanggal Pengingat",
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: ColorPalettes.gray),
          ),
          const Spacer(),
          const Icon(
            Icons.date_range,
            color: ColorPalettes.primary,
          )
        ],
      ),
    );
  }

  Row _buildCheckBox(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: false,
            onChanged: (_) {},
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
    );
  }

  Row _buildButtons(BuildContext context) {
    return Row(
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
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Row _buildDivider() {
    return Row(
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
