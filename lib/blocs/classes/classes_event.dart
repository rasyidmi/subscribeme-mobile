part of 'classes_bloc.dart';

abstract class ClassesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchClassById extends ClassesEvent {
  final int id;

  FetchClassById(this.id);

  @override
  List<Object?> get props => [id];
}

class SubscribeClass extends ClassesEvent {
  final int id;

  SubscribeClass(this.id);
  @override
  List<Object?> get props => [id];
}

class FetchUserClass extends ClassesEvent {}
