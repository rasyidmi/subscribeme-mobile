import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/class.dart';

class ClassesApi {
  final _classesPath = '/siakng/class';

  Future<List<Class>> getUserClass() async {
    final response = await RequestHelper.get('$_classesPath/npm');
    List<Class> classes = [];
    if (response.status == ResponseStatus.success) {
      for (var i = 0; i < response.data!["data"].length; i++) {
        final classData = Class.fromJson(response.data!["data"][i]);
        classes.add(classData);
      }
    }
    return classes;
  }

  Future<List<Class>> getLectureClass() async {
    final response = await RequestHelper.get('$_classesPath/nim');
    List<Class> classes = [];
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      final course = response.data!["data"];
      for (var i = 0; i < course.length; i++) {
        final classList = course[i]["class_detail"];
        for (var y = 0; y < classList.length; y++) {
          final classData = Class(
            classCode: classList[y]["class_code"],
            name: classList[y]["class_name"],
            courseCode: course[i]["course_code"],
            courseName: course[i]["course_name"],
            lectureName: classList[y]["lectures"],
            credit: course[i]["total_sks"],
            curriculumCode: course[i]["curriculum_code"],
          );
          classes.add(classData);
        }
      }
    }
    return classes;
  }

  Future<void> subscribeClass(int id) async {
    final response =
        await RequestHelper.post('$_classesPath/subscribe/$id', null);

    if (response.status != ResponseStatus.success) {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }
}
