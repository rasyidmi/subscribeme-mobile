import 'package:get_it/get_it.dart';
import 'package:subscribeme_mobile/api/api.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator
  ..registerLazySingleton(() => AuthApi())
  ..registerLazySingleton(() => CoursesApi())
  ..registerLazySingleton(() => ClassesApi())
  ..registerLazySingleton(() => EventsApi())
  ;
        
}
