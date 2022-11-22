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

//Get courses
class LoadCoursesSuccess extends CoursesState {
  final List<Course> listCourses;

  const LoadCoursesSuccess(this.listCourses);

  @override
  List<Object?> get props => [listCourses];
}

class LoadCoursesLoading extends CoursesState {}

class LoadCoursesFailed extends CoursesState {
  const LoadCoursesFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

// Create courses
class CreateCourseSuccess extends CoursesState {}

class CreateCourseFailed extends CoursesState {
  const CreateCourseFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class CreateCourseLoading extends CoursesState {}

// Get course's classes
class ClassesLoading extends CoursesState {}

class ClassesLoaded extends CoursesState {
  final List<Class> listClasses;

  const ClassesLoaded(this.listClasses);

  @override
  List<Object?> get props => [listClasses];
}

class LoadClassesFailed extends CoursesState {
  const LoadClassesFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

// Delete course
class DeleteCourseLoading extends CoursesState {}

class DeleteCourseSuccess extends CoursesState {}

class DeleteCourseFailed extends CoursesState {
  const DeleteCourseFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
