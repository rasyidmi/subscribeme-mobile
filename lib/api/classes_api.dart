import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/models/event.dart';

class ClassesApi {
  final _classesPath = '/class';

  Future<Class> getClassById(int id) async {
    final response = await RequestHelper.get('$_classesPath/$id');

    if (response.status == ResponseStatus.success) {
      Class kelas = Class.fromJson(response.data!["data"]);
      List<Event> listEvents = [];
      for (var event in response.data!["data"]["Events"]) {
        listEvents.add(Event.fromJson(event));
      }
      // Sort event ascending by deadline time
      listEvents.sort();
      kelas.listEvent = listEvents;
      return kelas;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  Future<void> subscribeClass(int id) async {
    final response =
        await RequestHelper.post('$_classesPath/subscribe/$id', null);

    if (response.status != ResponseStatus.success) {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }
}
