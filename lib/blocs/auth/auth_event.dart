part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Register extends AuthEvent {
  final Map<String, dynamic> data;

  Register(this.data);
  @override
  List<Object?> get props => [data];
}

class Login extends AuthEvent {
  final Map<String, dynamic> data;

  Login(this.data);
  @override
  List<Object?> get props => [data];
}

class AutoLogin extends AuthEvent {}

class Logout extends AuthEvent {}
