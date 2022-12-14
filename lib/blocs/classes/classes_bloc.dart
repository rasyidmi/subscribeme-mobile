import 'dart:developer';

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
    on<FetchClassById>(_onFetchClassById);
    on<SubscribeClass>(_onSubscribeClass);
  }

  Future<void> _onFetchClassById(
      FetchClassById event, Emitter<ClassesState> emit) async {
    emit(FetchClassLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final kelas = await _classesRepository.getClassById(event.id);
      emit(FetchClassSuccess(kelas));
    } on SubsHttpException catch (e) {
      emit(FetchClassFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const FetchClassFailed(status: ResponseStatus.maintenance));
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
