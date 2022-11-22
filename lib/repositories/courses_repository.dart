import 'package:subscribeme_mobile/api/courses_api.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/models/course.dart';

class CoursesRepository {
  final CoursesApi _coursesApi;

  CoursesRepository(this._coursesApi);

  Future<List<Course>> getAllCourses() async {
    return _coursesApi.getAllCourses();
  }

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> createCourse(Map<String, dynamic>? body) async {
    return _coursesApi.createCourse(body);
  }

  Future<List<Class>> getCourseClasses(int id) async {
    return _coursesApi.getCourseClasses(id);
  }

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> deleteCourse(int id) async {
     return _coursesApi.deleteCourse(id);
  }
}
