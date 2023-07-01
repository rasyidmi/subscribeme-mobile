import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/event.dart';

class EventsApi {
  Future<bool> setReminder(Event event, DateTime time) async {
    final Map<String, dynamic> body = {
      "set_time": time.toUtc().toIso8601String(),
      "event_id": event.eventId,
      "type": event.type,
    };
    final response = await RequestHelper.post("/reminder", body);
    if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      return true;
    }
    return false;
  }

  Future<bool> completeEvent(String id) async {
    final Map<String, dynamic> body = {"is_done": true};
    final response = await RequestHelper.put("/course/event/$id", body);
     if (response.status == ResponseStatus.success &&
        response.data!["data"] != null) {
      return true;
    }
    return false;
  }
}
