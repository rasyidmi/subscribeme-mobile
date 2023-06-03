import 'package:subscribeme_mobile/api/courses_api.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/models/course_scele.dart';

class CoursesRepository {
  final CoursesApi _coursesApi;

  CoursesRepository(this._coursesApi);

  Future<List<Course>> getUserCourses() async {
    return _coursesApi.getUserCourses();
  }

  Future<List<CourseScele>> getSubscribedCourse() async {
    return _coursesApi.getSubscribedCourse();
  }

  Future<bool> subscribeCourse(Course course) async {
    return _coursesApi.subscribeCourse(course);
  }
}
