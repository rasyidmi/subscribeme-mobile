part of 'courses_bloc.dart';

abstract class CoursesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateCourse extends CoursesEvent {
  final Map<String, dynamic> data;

  CreateCourse(this.data);
  @override
  List<Object?> get props => [data];
}

class FetchCourses extends CoursesEvent {}

class FetchCourseClasses extends CoursesEvent {
  final int id;

  FetchCourseClasses(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteCourse extends CoursesEvent {
  final int id;

  DeleteCourse(this.id);
  @override
  List<Object?> get props => [id];
}