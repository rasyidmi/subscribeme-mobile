part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetReminder extends EventsEvent {
  final Event event;
  final DateTime time;

  SetReminder(this.event, this.time);
}

class CreateEvent extends EventsEvent {
  final Map<String, dynamic> data;

  CreateEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class DeleteEvent extends EventsEvent {
  final int id;
  DeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchHomeData extends EventsEvent {}
