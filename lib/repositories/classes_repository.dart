import 'package:subscribeme_mobile/api/classes_api.dart';
import 'package:subscribeme_mobile/models/class.dart';

class ClassesRepository {
    final ClassesApi _classesApi;

  ClassesRepository(this._classesApi);

  Future<Class> getClassById(int id) async {
    return _classesApi.getClassById(id);
  }

  Future<void> subscribeClass(int id) async {
    return _classesApi.subscribeClass(id);
  }
}