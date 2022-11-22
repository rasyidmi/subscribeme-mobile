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

// Create event
class CreateEventLoading extends EventsState {}

class CreateEventSuccess extends EventsState {}

class CreateEventFailed extends EventsState {
  const CreateEventFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

// Delete event
class DeleteEventLoading extends EventsState {}

class DeleteEventSuccess extends EventsState {}

class DeleteEventFailed extends EventsState {
  const DeleteEventFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
