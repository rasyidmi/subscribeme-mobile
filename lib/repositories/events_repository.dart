import 'package:subscribeme_mobile/api/events_api.dart';
import 'package:subscribeme_mobile/models/student_event.dart';

class EventsRepository {
  final EventsApi _eventsApi;

  EventsRepository(this._eventsApi);

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> createEvent(Map<String, dynamic>? body) async {
    return _eventsApi.createEvent(body);
  }

  // Actually no need to return bool, but somehow if the return value is void
  // when server is down the error is not catched.
  Future<bool> deleteEvent(int id) async {
    return _eventsApi.deleteEvent(id);
  }

  Future<List<StudentEventModel>> getTodayDeadline() async {
    return _eventsApi.getTodayDeadline();
  }

  Future<List<StudentEventModel>> getSevenDayDeadline() async {
    return _eventsApi.getSevenDayDeadline();
  }
}
