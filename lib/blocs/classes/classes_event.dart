part of 'classes_bloc.dart';

abstract class ClassesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscribeClass extends ClassesEvent {
  final int id;

  SubscribeClass(this.id);
  @override
  List<Object?> get props => [id];
}

class FetchUserClass extends ClassesEvent {}

class FetchLectureClass extends ClassesEvent {}
