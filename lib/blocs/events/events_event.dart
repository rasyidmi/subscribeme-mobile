part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetReminder extends EventsEvent {
  final Event event;
  final DateTime? time;

  SetReminder(this.event, this.time);
}