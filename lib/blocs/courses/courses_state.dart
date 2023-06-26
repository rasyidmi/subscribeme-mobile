part of 'courses_bloc.dart';

abstract class CoursesState extends BlocState {
  const CoursesState({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class CoursesInit extends CoursesState {}

class FetchUserCoursesSuccess extends CoursesState {
  final List<Course> courses;
  const FetchUserCoursesSuccess(this.courses);

  @override
  List<Object?> get props => [courses];
}

class FetchUserCoursesLoading extends CoursesState {}

class FetchUserCoursesFailed extends CoursesState {
  const FetchUserCoursesFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class FetchSubscribedCoursesSuccess extends CoursesState {
  final List<CourseScele> courses;
  const FetchSubscribedCoursesSuccess(this.courses);

  @override
  List<Object?> get props => [courses];
}

class FetchSubscribedCoursesLoading extends CoursesState {}

class FetchSubscribedCoursesFailed extends CoursesState {
  const FetchSubscribedCoursesFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class SubscribeCourseSuccess extends CoursesState {}

class SubscribeCourseLoading extends CoursesState {}

class SubscribeCourseFailed extends CoursesState {
  const SubscribeCourseFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class FetchCourseEventsSuccess extends CoursesState {
  final List<Event> events;

  const FetchCourseEventsSuccess(this.events);
  @override
  List<Object?> get props => [events];
}

class FetchCourseEventsLoading extends CoursesState {}

class FetchCourseEventsFailed extends CoursesState {
  const FetchCourseEventsFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class FetchHomeDataSuccess extends CoursesState {
  final List<Event> todayDeadline;
  final List<Event> sevenDayDeadline;

  const FetchHomeDataSuccess({
    required this.todayDeadline,
    required this.sevenDayDeadline,
  });
  @override
  List<Object?> get props => [todayDeadline, sevenDayDeadline];
}

class FetchHomeDataLoading extends CoursesState {}

class FetchHomeDataFailed extends CoursesState {
  const FetchHomeDataFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
