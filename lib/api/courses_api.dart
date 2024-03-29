import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/models/course_scele.dart';
import 'package:subscribeme_mobile/models/event.dart';

class CoursesApi {
  final _coursesPath = '/course';

  Future<List<Course>> getUserCourses() async {
    final response =
        await RequestHelper.get('/moodle${_coursesPath}s/username');

    List<Course> listCourses = [];
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      for (var i = 0; i < response.data!["data"].length; i++) {
        final course = Course.fromJson(response.data!["data"][i]);
        listCourses.add(course);
      }
    }

    return listCourses;
  }

  Future<List<CourseScele>> getSubscribedCourse() async {
     // Check is user enable save data.
    final isUserExists = await RequestHelper.isUserExists();
    if (!isUserExists) {
      throw SubsHttpException(
        ResponseStatus.saveDataDisabled,
        "Kamu tidak mengizinkan penyimpanan data, fitur ini tidak bisa digunakan.",
      );
    }

    final response = await RequestHelper.get(_coursesPath);
    List<CourseScele> listCourses = [];
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      for (var i = 0; i < response.data!["data"].length; i++) {
        final course = CourseScele.fromJson(response.data!["data"][i]);
        listCourses.add(course);
      }
    }

    return listCourses;
  }

  Future<List<Event>> getCourseEvents(String courseId) async {
    final response = await RequestHelper.get('$_coursesPath/event/$courseId');
    List<Event> events = [];
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      for (var i = 0; i < response.data!["data"].length; i++) {
        final event = Event.fromJson(response.data!["data"][i]);
        events.add(event);
      }
    }
    return events;
  }

  Future<bool> subscribeCourse(Course subscribedCourse) async {
    final body = subscribedCourse.toJson();
    final response = await RequestHelper.post('$_coursesPath/subscribe', body);
    return response.status == ResponseStatus.success;
  }

  Future<bool> unsubscribeCourse(Course unsubscribeCourse) async {
    final body = unsubscribeCourse.toJson();
    final response =
        await RequestHelper.post('$_coursesPath/unsubscribe', body);
    return response.status == ResponseStatus.success;
  }

  Future<List<Event>> getTodayDeadline() async {
    // Check is user enable save data.
    final isUserExists = await RequestHelper.isUserExists();
    if (!isUserExists) {
      throw SubsHttpException(
        ResponseStatus.saveDataDisabled,
        "Kamu tidak mengizinkan penyimpanan data, fitur ini tidak bisa digunakan.",
      );
    }

    final response = await RequestHelper.get('$_coursesPath/deadline/today');
    List<Event> events = [];
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      for (var i = 0; i < response.data!["data"].length; i++) {
        final event = Event.fromJson(response.data!["data"][i]);
        events.add(event);
      }
    }
    return events;
  }

  Future<List<Event>> getSevenDayDeadline() async {
    // Check is user enable save data.
    final isUserExists = await RequestHelper.isUserExists();
    if (!isUserExists) {
      throw SubsHttpException(
        ResponseStatus.saveDataDisabled,
        "Kamu tidak mengizinkan penyimpanan data, fitur ini tidak bisa digunakan.",
      );
    }

    final response = await RequestHelper.get('$_coursesPath/deadline/7-days');
    List<Event> events = [];
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      for (var i = 0; i < response.data!["data"].length; i++) {
        final event = Event.fromJson(response.data!["data"][i]);
        events.add(event);
      }
    }
    return events;
  }
}
