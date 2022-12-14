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

class FetchClassLoading extends ClassesState {}

class FetchClassSuccess extends ClassesState {
  final Class kelas;

  const FetchClassSuccess(this.kelas);

  @override
  List<Object?> get props => [kelas];
}

class FetchClassFailed extends ClassesState {
  const FetchClassFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class SubscribeClassSuccess extends ClassesState {}

class SubscribeClassLoading extends ClassesState {}

class SubscribeClassFailed extends ClassesState {
  const SubscribeClassFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
