import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/class.dart';
import 'package:subscribeme_mobile/repositories/classes_repository.dart';

part 'classes_event.dart';
part 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  final ClassesRepository _classesRepository;

  ClassesBloc(this._classesRepository) : super(ClassesInit()) {
    on<FetchUserClass>(_onFetchUserClass);
    on<SubscribeClass>(_onSubscribeClass);
    on<FetchLectureClass>(_onFetchLectureClass);
  }

  Future<void> _onFetchUserClass(
      FetchUserClass event, Emitter<ClassesState> emit) async {
    emit(FetchClassLoading());
    try {
      final classesData = await _classesRepository.getUserClass();
      emit(FetchUserClassSuccess(classesData));
    } on SubsHttpException catch (e) {
      emit(FetchUserClassFailed(
        status: e.status,
        message: e.message,
      ));
    }
  }

  Future<void> _onFetchLectureClass(
      FetchLectureClass event, Emitter<ClassesState> emit) async {
    emit(FetchLectureClassLoading());
    try {
      final classesData = await _classesRepository.getLectureClass();
      emit(FetchLectureClassSuccess(classesData));
    } on SubsHttpException catch (e) {
      emit(FetchLectureClassFailed(
        status: e.status,
        message: e.message,
      ));
    }
  }

  Future<void> _onSubscribeClass(
      SubscribeClass event, Emitter<ClassesState> emit) async {
    emit(SubscribeClassLoading());
    try {
      await _classesRepository.subscribeClass(event.id);
      emit(SubscribeClassSuccess());
    } on SubsHttpException catch (e) {
      emit(SubscribeClassFailed(
        status: e.status,
        message: e.message,
      ));
    }
  }
}
