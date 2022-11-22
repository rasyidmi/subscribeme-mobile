part of 'classes_bloc.dart';

abstract class ClassesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchClassEvents extends ClassesEvent {
  final int id;

  FetchClassEvents(this.id);

  @override
  List<Object?> get props => [id];
}