import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/models/course.dart';

class CoursesApi {
  final _coursesPath = '/mata-kuliah';

  Future<List<Course>> getAllCourses() async {
    final response = await RequestHelper.get(_coursesPath);

    if (response.status == ResponseStatus.success) {
      List<Course> listCourses = [];
      for (var course in response.data!["data"]) {
        listCourses.add(Course.fromJson(course));
      }
      return listCourses;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> createCourse(Map<String, dynamic>? body) async {
    final response = await RequestHelper.post(_coursesPath, body);

    if (response.status == ResponseStatus.success) {
      return true;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> deleteCourse(int id) async {
    final response = await RequestHelper.delete('$_coursesPath/$id');

    if (response.status == ResponseStatus.success) {
      return true;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  Future<List<Class>> getCourseClasses(int id) async {
    final response = await RequestHelper.get('$_coursesPath/$id');

    if (response.status == ResponseStatus.success) {
      List<Class> listClasses = [];
      for (var classs in response.data!["data"]["Classes"]) {
        listClasses.add(Class.fromJson(classs));
      }
      return listClasses;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }
}
