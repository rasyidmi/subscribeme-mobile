part of 'events_bloc.dart';

abstract class EventsState extends BlocState {
  const EventsState({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class EventsInitial extends EventsState {}

class SetReminderSuccess extends EventsState {}

class SetReminderLoading extends EventsState {}

class SetReminderFailed extends EventsState {
  const SetReminderFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}