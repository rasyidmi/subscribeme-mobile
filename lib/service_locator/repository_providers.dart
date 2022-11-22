import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/api/api.dart';
import 'package:subscribeme_mobile/repositories/repositories.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';

final repositoryProviders = [
  RepositoryProvider<AuthRepository>(
    create: (context) => AuthRepository(locator<AuthApi>()),
  ),
  RepositoryProvider<CoursesRepository>(
    create: (context) => CoursesRepository(locator<CoursesApi>()),
  ),
  RepositoryProvider<ClassesRepository>(
    create: (context) => ClassesRepository(locator<ClassesApi>()),
  ),
  RepositoryProvider<EventsRepository>(
      create: (context) => EventsRepository(locator<EventsApi>()))
];
