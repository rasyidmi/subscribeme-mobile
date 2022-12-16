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

// Fetch today deadlines.
class FetchTodayDeadlineSuccess extends EventsState {
  final List<StudentEventModel> events;

  const FetchTodayDeadlineSuccess(this.events);

  @override
  List<Object?> get props => [events];
}

class FetchTodayDeadlineFailed extends EventsState {
  const FetchTodayDeadlineFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
class FetchTodayDeadlineLoading extends EventsState {}

