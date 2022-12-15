import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/classes/classes_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/date_time_extension.dart';
import 'package:subscribeme_mobile/commons/extensions/string_extension.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/repositories/classes_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/circular_loading.dart';
import 'package:subscribeme_mobile/widgets/class_detail/rectangle_button.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/shimmer/list_shimmer.dart';
import 'package:subscribeme_mobile/widgets/subs_bottomsheet.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_secondary_button.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final classInstance = classData["class_data"] as Class;
    final courseName = classData["course_name"] as String;
    bool isChecked = false;

    return BlocProvider<ClassesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<ClassesRepository>(context);
        return ClassesBloc(repository)
          ..add(FetchClassById(classData['class_data'].id));
      },
      child: ColoredBox(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: SecondaryAppbar(
              title: classInstance.title,
              subTitle: courseName,
              padding: const EdgeInsets.only(top: 8.0),
            ),
            body: SubsConsumer<ClassesBloc, ClassesState>(
              listener: (context, state) {
                if (state is SubscribeClassSuccess) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.classDetail,
                    (route) => route.settings.name == Routes.courseDetail,
                    arguments: {
                      'class_data': classInstance,
                      'course_name': courseName,
                    },
                  );
                  SubsFlushbar.showSuccess(
                      context, "Berhasil subscribe kelas.");
                }
              },
              builder: (context, state) {
                if (state is FetchClassSuccess) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.kelas.listEvent!.length,
                              itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SubsListTile(
                                  title: state.kelas.listEvent![index].title,
                                  secondLine: state.kelas.listEvent![index]
                                      .deadlineTime.displayDeadline,
                                  isActive: state.kelas.isSubscribe!,
                                  onTap: state.kelas.isSubscribe!
                                      ? () {
                                          _showBottomSheet(
                                            context,
                                            state,
                                            index,
                                            courseName,
                                            classInstance,
                                            isChecked,
                                          );
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListShimmer(itemHeight: 64.0),
                  );
                }
              },
            ),
            bottomNavigationBar: BlocBuilder<ClassesBloc, ClassesState>(
              builder: (context, state) {
                if (state is FetchClassSuccess && !state.kelas.isSubscribe!) {
                  return Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, -4),
                          blurRadius: 4,
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
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return const Center(child: CircularLoading());
                                });
                            BlocProvider.of<ClassesBloc>(context)
                                .add(SubscribeClass(classInstance.id));
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  PersistentBottomSheetController<dynamic> _showBottomSheet(
      BuildContext context,
      FetchClassSuccess state,
      int index,
      String courseName,
      Class classInstance,
      bool isChecked) {
    return showBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SubsBottomsheet(content: [
            const Spacer(),
            Text(
              state.kelas.listEvent![index].title,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: ColorPalettes.primary),
            ),
            const SizedBox(height: 10),
            Text(
              'Deadline: ${state.kelas.listEvent![index].deadlineTime.toDayMonthYearFormat}',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: ColorPalettes.lightRed, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelas: $courseName - ${classInstance.title.getLastCharacter}',
            ),
            const SizedBox(height: 20),
            _buildBellTile(context),
            const SizedBox(height: 20),
            _buildNotificationPicker(),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 24),
            Row(
              children: [
                _CheckBox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    }),
                const SizedBox(width: 16),
                Text(
                  "Tandai Sudah Selesai",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Spacer(flex: 2),
            _buildBottomsheetButtons(context),
          ]);
        },
      ),
    );
  }

  Row _buildBottomsheetButtons(BuildContext context) {
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
      children: const [
        _SmallDivider(),
        SizedBox(width: 12),
        Text("atau"),
        SizedBox(width: 12),
        _SmallDivider(),
      ],
    );
  }

  Row _buildNotificationPicker() {
    return Row(
      children: const [
        RectangleButton(
          backgroundColor: ColorPalettes.secondary,
          icon: Icon(Icons.remove),
        ),
        Spacer(),
        Text("1 Hari - Sebelum Deadline"),
        Spacer(),
        RectangleButton(
          backgroundColor: ColorPalettes.primary,
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Row _buildBellTile(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.notifications),
        const SizedBox(width: 16),
        Text(
          "Ingatkan Aku Sebelum?",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.bold),
        ),
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

class _CheckBox extends StatelessWidget {
  final bool? value;
  final void Function(bool?) onChanged;
  const _CheckBox({
    Key? key,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.black,
        ),
        child: Checkbox(
          value: value,
          activeColor: ColorPalettes.primary,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
