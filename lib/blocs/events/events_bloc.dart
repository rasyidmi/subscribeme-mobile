import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/student_event.dart';
import 'package:subscribeme_mobile/repositories/events_repository.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository _eventsRepository;

  EventsBloc(this._eventsRepository) : super(EventsInitial()) {
    on<CreateEvent>(_onCreateEventHandler);
    on<DeleteEvent>(_onDeleteEventHandler);
    on<FetchHomeData>(_onFetchHomeDataHandler);
  }

  Future<void> _onCreateEventHandler(
      CreateEvent event, Emitter<EventsState> emit) async {
    emit(CreateEventLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await _eventsRepository.createEvent(event.data);
      emit(CreateEventSuccess());
    } on SubsHttpException catch (e) {
      emit(CreateEventFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const CreateEventFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onDeleteEventHandler(
      DeleteEvent event, Emitter<EventsState> emit) async {
    emit(DeleteEventLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await _eventsRepository.deleteEvent(event.id);
      emit(DeleteEventSuccess());
    } on SubsHttpException catch (e) {
      emit(DeleteEventFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const DeleteEventFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onFetchHomeDataHandler(
      FetchHomeData event, Emitter<EventsState> emit) async {
    emit(FetchHomeDataLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final todayDeadline = await _eventsRepository.getTodayDeadline();
      final sevenDayDeadline = await _eventsRepository.getSevenDayDeadline();
      emit(FetchHomeDataSuccess(
        todayDeadline: todayDeadline,
        sevenDayDeadline: sevenDayDeadline,
      ));
    } on SubsHttpException catch (e) {
      emit(FetchHomeDataFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const FetchHomeDataFailed(status: ResponseStatus.maintenance));
    }
  }
}
