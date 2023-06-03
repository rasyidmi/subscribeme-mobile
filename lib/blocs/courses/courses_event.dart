part of 'courses_bloc.dart';

abstract class CoursesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserCourses extends CoursesEvent {}

class FetchSubscribedCourses extends CoursesEvent {}

class SubscribeCourse extends CoursesEvent {
  final Course course;

  SubscribeCourse(this.course);
  @override
  List<Object?> get props => [course];
}
