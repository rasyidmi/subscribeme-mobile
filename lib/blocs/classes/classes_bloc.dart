import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/event.dart';
import 'package:subscribeme_mobile/repositories/classes_repository.dart';

part 'classes_event.dart';
part 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  final ClassesRepository _classesRepository;

  ClassesBloc(this._classesRepository) : super(ClassesInit()) {
    on<FetchClassEvents>(_onFetchClassEvents);
  }

  Future<void> _onFetchClassEvents(
      FetchClassEvents event, Emitter<ClassesState> emit) async {
    emit(FetchEventsLoading());
    await Future.delayed(const Duration(seconds: 1));
    try {
      final listEvents = await _classesRepository.getEventsClass(event.id);
      emit(FetchEventsSuccess(listEvents));
    } on SubsHttpException catch (e) {
      emit(FetchEventsFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const FetchEventsFailed(status: ResponseStatus.maintenance));
    }
  }
}
