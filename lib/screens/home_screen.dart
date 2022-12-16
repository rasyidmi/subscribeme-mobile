import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/events/events_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/extensions/string_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/repositories/events_repository.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<EventsRepository>(context);
        return EventsBloc(repository)..add(FetchTodayDeadline());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                SubsConsumer<EventsBloc, EventsState>(
                  builder: (context, state) {
                    if (state is FetchTodayDeadlineSuccess) {
                      final events = state.events;
                      return Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: ColorPalettes.primary,
                                child: Center(
                                  child: Text(
                                    events.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Deadline Hari Ini',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: ColorPalettes.primary),
                                  ),
                                  Text(
                                    DateTime.now().toDayMonthYearFormat,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = state.events[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SubsListTile(
                                  title: event.title,
                                  secondLine:
                                      '${event.courseTitle} - ${event.className.getLastCharacter}',
                                  thirdLine: event.deadlineDate.displayDeadline,
                                  onTap: () {},
                                  isActive: true,
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
                // const SizedBox(height: 16.0),
                // Text(
                //   'Deadline 7 Hari ke Depan!',
                //   style: Theme.of(context)
                //       .textTheme
                //       .subtitle1!
                //       .copyWith(color: ColorPalettes.primary),
                // ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
