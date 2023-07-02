import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/course.dart';
import 'package:subscribeme_mobile/models/course_scele.dart';
import 'package:subscribeme_mobile/models/event.dart';
import 'package:subscribeme_mobile/repositories/courses_repository.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CoursesRepository _coursesRepository;

  CoursesBloc(this._coursesRepository) : super(CoursesInit()) {
    on<FetchUserCourses>(_onFetchUserCourses);
    on<SubscribeCourse>(_onSubscribeCourse);
    on<UnsubscribeCourse>(_onUnsubscribeCourseHandler);
    on<SubscribeCourseFinished>(_onSubscribeCourseFinished);
    on<FetchSubscribedCourses>(_onFetchSubscribedCoursesHandler);
    on<FetchCourseEvents>(_onFetchCourseEvents);
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchUserCourses(
      FetchUserCourses event, Emitter<CoursesState> emit) async {
    emit(FetchUserCoursesLoading());
    try {
      final listCourses = await _coursesRepository.getUserCourses();
      emit(FetchUserCoursesSuccess(listCourses));
    } on SubsHttpException catch (e) {
      emit(
        FetchUserCoursesFailed(
          status: e.status,
          message: e.message,
        ),
      );
    } catch (f) {
      log('ERROR: $f');
      emit(const FetchUserCoursesFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onSubscribeCourse(
      SubscribeCourse event, Emitter<CoursesState> emit) async {
    emit(SubscribeCourseLoading());
    try {
      final isSuccess = await _coursesRepository.subscribeCourse(event.course);
      if (!isSuccess) {
        emit(const SubscribeCourseFailed(status: ResponseStatus.failed));
      }
    } on SubsHttpException catch (e) {
      emit(
        SubscribeCourseFailed(
          status: e.status,
          message: e.message,
        ),
      );
    } catch (f) {
      log('ERROR: $f');
      emit(const SubscribeCourseFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onUnsubscribeCourseHandler(
      UnsubscribeCourse event, Emitter<CoursesState> emit) async {
    emit(SubscribeCourseLoading());
    try {
      final isSuccess =
          await _coursesRepository.unsubscribeCourse(event.course);
      if (!isSuccess) {
        emit(const SubscribeCourseFailed(status: ResponseStatus.failed));
      }
    } on SubsHttpException catch (e) {
      emit(
        SubscribeCourseFailed(
          status: e.status,
          message: e.message,
        ),
      );
    } catch (f) {
      log('ERROR: $f');
      emit(const SubscribeCourseFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onSubscribeCourseFinished(
      SubscribeCourseFinished event, Emitter<CoursesState> emit) async {
    emit(SubscribeCourseSuccess());
  }

  Future<void> _onFetchSubscribedCoursesHandler(
      FetchSubscribedCourses event, Emitter<CoursesState> emit) async {
    emit(FetchUserCoursesLoading());
    try {
      final listCourses = await _coursesRepository.getSubscribedCourse();
      emit(FetchSubscribedCoursesSuccess(listCourses));
    } on SubsHttpException catch (e) {
      emit(
        FetchSubscribedCoursesFailed(
          status: e.status,
          message: e.message,
        ),
      );
    } catch (f) {
      log('ERROR: $f');
      emit(const FetchSubscribedCoursesFailed(
          status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onFetchCourseEvents(
      FetchCourseEvents event, Emitter<CoursesState> emit) async {
    emit(FetchCourseEventsLoading());
    try {
      final events = await _coursesRepository.getCourseEvents(event.courseId);
      emit(FetchCourseEventsSuccess(events));
    } on SubsHttpException catch (e) {
      emit(
        FetchUserCoursesFailed(
          status: e.status,
          message: e.message,
        ),
      );
    } catch (f) {
      log('ERROR: $f');
      emit(const FetchSubscribedCoursesFailed(
          status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onFetchHomeData(
      FetchHomeData event, Emitter<CoursesState> emit) async {
    emit(FetchHomeDataLoading());
    try {
      final todayDeadline = await _coursesRepository.getTodayDeadline();
      final sevenDayDeadline = await _coursesRepository.getSevenDayDeadline();
      emit(FetchHomeDataSuccess(
        todayDeadline: todayDeadline,
        sevenDayDeadline: sevenDayDeadline,
      ));
    } on SubsHttpException catch (e) {
      emit(
        FetchHomeDataFailed(
          status: e.status,
          message: e.message,
        ),
      );
    } catch (f) {
      log('ERROR: $f');
      emit(const FetchHomeDataFailed(status: ResponseStatus.maintenance));
    }
  }
}
