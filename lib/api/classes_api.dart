import 'dart:developer';
import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/class.dart';

class ClassesApi {
  final _classesPath = '/siakng/class';

  // Future<Class> getClassById(int id) async {
  //   final response = await RequestHelper.get('$_classesPath/$id');

  //   if (response.status == ResponseStatus.success) {
  //     Class kelas = Class.fromJson(response.data!["data"]);
  //     List<Event> listEvents = [];
  //     for (var event in response.data!["data"]["Events"]) {
  //       listEvents.add(Event.fromJson(event));
  //     }
  //     // Sort event ascending by deadline time
  //     listEvents.sort();
  //     kelas.listEvent = listEvents;
  //     return kelas;
  //   } else {
  //     throw SubsHttpException(response.status, response.data!["data"]);
  //   }
  // }

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

  Future<void> subscribeClass(int id) async {
    final response =
        await RequestHelper.post('$_classesPath/subscribe/$id', null);

    if (response.status != ResponseStatus.success) {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }
}
