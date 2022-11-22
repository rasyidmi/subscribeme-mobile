import 'package:subscribeme_mobile/api/classes_api.dart';
import 'package:subscribeme_mobile/models/event.dart';

class ClassesRepository {
    final ClassesApi _classesApi;

  ClassesRepository(this._classesApi);

  Future<List<Event>> getEventsClass(int id) async {
    return _classesApi.getEventsClass(id);
  }
}