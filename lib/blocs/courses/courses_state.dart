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
