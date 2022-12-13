import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';

class EventsApi {
  final _eventsPath = '/event';

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> deleteEvent(int id) async {
    final response = await RequestHelper.delete('$_eventsPath/delete/$id');

    if (response.status == ResponseStatus.success) {
      return true;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> createEvent(Map<String, dynamic>? body) async {
    final response = await RequestHelper.post('$_eventsPath/create', body);

    if (response.status == ResponseStatus.success) {
      return true;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }
}
