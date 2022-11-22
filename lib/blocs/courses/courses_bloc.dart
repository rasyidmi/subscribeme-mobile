import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CoursesRepository _coursesRepository;

  CoursesBloc(this._coursesRepository) : super(CoursesInit()) {
    on<FetchCourses>(_onFetchCourses);
    on<FetchCourseClasses>(_onFetchCourseClasses);
    on<CreateCourse>(_onCreateCourse);
    on<DeleteCourse>(_onDeleteCourseHandler);
  }

  Future<void> _onFetchCourses(
      FetchCourses event, Emitter<CoursesState> emit) async {
    emit(LoadCoursesLoading());
    await Future.delayed(const Duration(seconds: 1), () {});

    try {
      final listCourses = await _coursesRepository.getAllCourses();
      emit(LoadCoursesSuccess(listCourses));
    } on SubsHttpException catch (e) {
      emit(
        LoadCoursesFailed(
          status: e.status,
          message: e.message,
        ),
      );
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const LoadCoursesFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onCreateCourse(
      CreateCourse event, Emitter<CoursesState> emit) async {
    emit(CreateCourseLoading());
    await Future.delayed(const Duration(seconds: 1), () {});
    try {
      await _coursesRepository.createCourse(event.data);
      emit(CreateCourseSuccess());
    } on SubsHttpException catch (e) {
      emit(CreateCourseFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const CreateCourseFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onFetchCourseClasses(
      FetchCourseClasses event, Emitter<CoursesState> emit) async {
    emit(ClassesLoading());
    try {
      final listClasses = await _coursesRepository.getCourseClasses(event.id);
      emit(ClassesLoaded(listClasses));
    } on SubsHttpException catch (e) {
      emit(LoadClassesFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const LoadClassesFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onDeleteCourseHandler(
      DeleteCourse event, Emitter<CoursesState> emit) async {
    emit(DeleteCourseLoading());
    await Future.delayed(const Duration(seconds: 1));
    try {
      await _coursesRepository.deleteCourse(event.id);
      emit(DeleteCourseSuccess());
    } on SubsHttpException catch (e) {
      emit(DeleteCourseFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const DeleteCourseFailed(status: ResponseStatus.maintenance));
    }
  }
}
