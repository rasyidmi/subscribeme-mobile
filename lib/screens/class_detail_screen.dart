import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/classes/classes_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/repositories/classes_repository.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: SecondaryAppbar(
        title: classData['class_data'].title,
        subTitle: classData['course_name'],
        padding: const EdgeInsets.only(top: 8.0),
      ),
      body: BlocProvider<ClassesBloc>(
        create: (_) {
          final repository = RepositoryProvider.of<ClassesRepository>(context);
          return ClassesBloc(repository)
            ..add(FetchClassEvents(classData['class_data'].id));
        },
        child: SubsConsumer<ClassesBloc, ClassesState>(
          builder: (context, state) {
            if (state is FetchEventsSuccess) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.listEvents.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SubsListTile(
                              title: state.listEvents[index].title,
                              secondLine: state.listEvents[index].deadlineTime
                                  .displayDeadline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
            } else {
              return const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.0),
                child: ListShimmer(itemHeight: 64.0),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -3),
                blurRadius: 1,
                spreadRadius: 0.5,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              const Text(
                '''*) Jika mengikuti kelas ini, kamu dapat mengatur dan mendapatkan notifikasi ketika terdapat tugas-tugas yang ada di kelas ini.''',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SubsRoundedButton(
                buttonText: 'Ikuti Kelas Ini',
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
