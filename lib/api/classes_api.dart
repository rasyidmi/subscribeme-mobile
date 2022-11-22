import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/event.dart';

class ClassesApi {
  final _classesPath = '/kelas';

  Future<List<Event>> getEventsClass(int id) async {
    final response = await RequestHelper.get('$_classesPath/$id');

    if (response.status == ResponseStatus.success) {
      List<Event> listEvents = [];
      for (var event in response.data!["data"]["Events"]) {
        listEvents.add(Event.fromJson(event));
      }
      // Sort event ascending by deadline time
      listEvents.sort();
      return listEvents;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }
}
