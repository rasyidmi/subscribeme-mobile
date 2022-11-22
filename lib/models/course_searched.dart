// Helper in Choose Course Screen
import 'package:subscribeme_mobile/models/course.dart';

class CourseSearched {
  final int id;
  final String title;
  final int searchIndex;

  CourseSearched(this.id, this.title, this.searchIndex);

  factory CourseSearched.fromCourse(Course course, int index) =>
      CourseSearched(course.id, course.title, index);
}
