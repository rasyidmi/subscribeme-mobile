import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/stateful_bottom_sheet.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoursesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<CoursesRepository>(context);
        return CoursesBloc(repository)..add(FetchHomeData());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                SubsConsumer<CoursesBloc, CoursesState>(
                  builder: (context, state) {
                    if (state is FetchHomeDataSuccess) {
                      final todayDeadline = state.todayDeadline;
                      final sevenDayDeadline = state.sevenDayDeadline;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: todayDeadline.isEmpty
                                    ? ColorPalettes.success
                                    : ColorPalettes.primary,
                                child: Center(
                                  child: Text(
                                    todayDeadline.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Deadline Hari Ini",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: ColorPalettes.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(DateTime.now().toDayMonthYearFormat),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          if (todayDeadline.isEmpty)
                            Center(
                              child: Image.asset(
                                SubsImages.salyComputer,
                                height: getScreenSize(context).height / 4,
                              ),
                            ),
                          if (todayDeadline.isEmpty)
                            Center(
                              child: Text(
                                "Horee! Tidak ada deadline hari ini!",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          if (todayDeadline.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: todayDeadline.length,
                              itemBuilder: (context, index) {
                                final event = state.todayDeadline[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: SubsListTile(
                                    title: event.name,
                                    secondLine: event.courseName,
                                    thirdLine:
                                        event.deadlineTime.displayDeadline,
                                    onTap: event.isDone ? null : () {},
                                    isActive: !event.isDone,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 16.0),
                          Text(
                            "Deadline 7 Hari ke Depan!",
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: ColorPalettes.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 16.0),
                          if (sevenDayDeadline.isEmpty)
                            Center(
                              child: Image.asset(
                                SubsImages.salyComputer,
                                height: getScreenSize(context).height / 4,
                              ),
                            ),
                          if (sevenDayDeadline.isEmpty)
                            Center(
                              child: Text(
                                "Horee! Tidak ada deadline 7 hari ke depan!",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          if (sevenDayDeadline.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: sevenDayDeadline.length,
                              itemBuilder: (context, index) {
                                final event = state.sevenDayDeadline[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: SubsListTile(
                                    title: event.name,
                                    fontSize: 12,
                                    secondLine: event.courseName,
                                    thirdLine:
                                        event.deadlineTime.displayDeadline,
                                    onTap: event.isDone
                                        ? null
                                        : () => showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) =>
                                                  StatefulBottomSheet(
                                                event: event,
                                                courseName: event.courseName,
                                              ),
                                            ),
                                    isActive: !event.isDone,
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    } else {
                      return const ListShimmer(itemHeight: 64);
                    }
                  },
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
