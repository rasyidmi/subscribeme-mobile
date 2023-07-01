import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/event.dart';
import 'package:subscribeme_mobile/repositories/events_repository.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository _eventsRepository;

  EventsBloc(this._eventsRepository) : super(EventsInitial()) {
    on<SetReminder>(_onSetReminder);
  }

  Future<void> _onSetReminder(
      SetReminder event, Emitter<EventsState> emit) async {
    emit(SetReminderLoading());
    try {
      bool setReminderResponse = true;
      if (event.time != null) {
        setReminderResponse =
            await _eventsRepository.setReminder(event.event, event.time!);
      }
      bool completeEventResponse = true;
      if (event.event.isDone) {
        completeEventResponse =
            await _eventsRepository.completeEvent(event.event.id);
      }

      if (setReminderResponse && completeEventResponse) {
        emit(SetReminderSuccess());
      } else {
        emit(const SetReminderFailed());
      }
    } catch (e) {
      log('ERROR: $e');
      emit(const SetReminderFailed(status: ResponseStatus.maintenance));
    }
  }
}
