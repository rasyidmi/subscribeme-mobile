import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/courses/courses_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/int_extension.dart';
import 'package:subscribeme_mobile/commons/extensions/string_extension.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/admin_menu/course/course_dropdown.dart';
import 'package:subscribeme_mobile/widgets/subs_consumer.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';
import 'package:subscribeme_mobile/widgets/subs_text_field.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _addCourseFormKey = GlobalKey<FormState>();
  TextEditingController courseNameController = TextEditingController();
  TextEditingController termController = TextEditingController();
  TextEditingController classTotal = TextEditingController();

  String? dropDownValue;
  bool isLoading = false;

  List<String> items = [
    'Ilmu Komputer',
    'Sistem Informasi',
  ];

  @override
  void dispose() {
    courseNameController.dispose();
    termController.dispose();
    classTotal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoursesBloc>(
      create: (_) {
        final repository = RepositoryProvider.of<CoursesRepository>(context);
        return CoursesBloc(repository);
      },
      child: Scaffold(
        appBar: const SecondaryAppbar(title: 'Tambah Mata Kuliah'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _createForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _createForm() {
    return Form(
      key: _addCourseFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubsTextField(
            label: 'Nama Mata Kuliah',
            hintText: 'Aljabar Linear',
            autocorrect: false,
            keyboardType: TextInputType.name,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
            controller: courseNameController,
            onChanged: (_) {
              // To update the state of the save button when
              // user change input
              setState(() {});
            },
          ),
          SubsTextField(
            label: 'Semester',
            hintText: '4',
            keyboardType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            controller: termController,
            onChanged: (_) {
              // To update the state of the save button when
              // user change input
              setState(() {});
            },
            validatorFunction: (value) {
              if (value == '0') {
                return 'Semester tidak boleh 0';
              } else if (int.parse(value!) > 8) {
                return 'Semester tidak boleh lebih dari 8';
              }
              return null;
            },
          ),
          const SizedBox(height: 24.0),
          const Text('Jurusan'),
          const SizedBox(height: 8.0),
          AddCourseDropdown(
            value: dropDownValue,
            dropdownItem: items,
            onChanged: (value) {
              setState(() {
                dropDownValue = value as String;
              });
            },
          ),
          SubsTextField(
              label: 'Jumlah Kelas',
              hintText: '4',
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
              controller: classTotal,
              onChanged: (_) {
                // To update the state of the save button when
                // user change input
                setState(() {});
              },
              validatorFunction: (value) {
                if (value == '0') {
                  return 'Jumlah kelas tidak boleh 0';
                }
                return null;
              }),
          const Spacer(),
          SafeArea(
            child: SubsConsumer<CoursesBloc, CoursesState>(
              listener: (context, state) {
                if (state is CreateCourseLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is CreateCourseSuccess) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.adminViewCourses,
                      (route) => route.settings.name == Routes.home);
                  SubsFlushbar.showSuccess(
                    context,
                    'Mata kuliah berhasil terbuat',
                  );
                } else if (state is CreateCourseFailed) {
                  setState(() {
                    isLoading = false;
                  });
                  SubsFlushbar.showFailed(
                    context,
                    'Terjadi kesalahan, silahkan coba lagi!',
                  );
                }
              },
              builder: (context, state) => SubsRoundedButton(
                isLoading: isLoading,
                buttonText: 'Simpan Mata Kuliah',
                onTap: _isFormsFilled ? () => _addCourse(context) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCourse(BuildContext context) {
    if (_addCourseFormKey.currentState!.validate()) {
      BlocProvider.of<CoursesBloc>(context).add(CreateCourse(_convertData));
    }
  }

  Map<String, dynamic> get _convertData {
    final List<Map<String, String>> classes = [];
    for (int i = 0; i < int.parse(classTotal.text); i++) {
      classes.add({'title': 'Kelas ${i.getAlphabet()}'});
    }
    return {
      'title': courseNameController.text.toTitleCase,
      'term': int.parse(termController.text),
      'major': dropDownValue,
      'classes': classes
    };
  }

  bool get _isFormsFilled {
    return dropDownValue != null &&
        courseNameController.text.isNotEmpty &&
        termController.text.isNotEmpty &&
        classTotal.text.isNotEmpty;
  }
}
