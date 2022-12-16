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
class FetchHomeDataSuccess extends EventsState {
  final List<StudentEventModel> todayDeadline;
  final List<StudentEventModel> sevenDayDeadline;

  const FetchHomeDataSuccess({
    required this.todayDeadline,
    required this.sevenDayDeadline,
  });

  @override
  List<Object?> get props => [todayDeadline, sevenDayDeadline];
}

class FetchHomeDataFailed extends EventsState {
  const FetchHomeDataFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class FetchHomeDataLoading extends EventsState {}
