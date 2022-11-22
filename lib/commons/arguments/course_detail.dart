import 'package:subscribeme_mobile/models/class.dart';

class CourseDetail {
  String courseTitle;
  int courseId;
  List<Class> listClasses;

  CourseDetail({
    required this.courseTitle,
    required this.courseId,
    required this.listClasses,
  });
}
