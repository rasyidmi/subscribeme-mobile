part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
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
