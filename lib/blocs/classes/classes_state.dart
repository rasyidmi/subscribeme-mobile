part of 'classes_bloc.dart';

abstract class ClassesState extends BlocState {
  const ClassesState({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class ClassesInit extends ClassesState {}

class FetchEventsLoading extends ClassesState {}

class FetchEventsSuccess extends ClassesState {
  final List<Event> listEvents;

  const FetchEventsSuccess(this.listEvents);

  @override
  List<Object?> get props => [listEvents];
}

class FetchEventsFailed extends ClassesState {
  const FetchEventsFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
