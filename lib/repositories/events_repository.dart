import 'package:subscribeme_mobile/api/events_api.dart';
import 'package:subscribeme_mobile/models/event.dart';

class EventsRepository {
  final EventsApi _eventsApi;

  EventsRepository(this._eventsApi);

  Future<bool> setReminder(Event event, DateTime time) async {
    return _eventsApi.setReminder(event, time);
  }

  Future<bool> completeEvent(String id) async {
    return _eventsApi.completeEvent(id);
  }
}
