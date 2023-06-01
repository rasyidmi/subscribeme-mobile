part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateUser extends AuthEvent {
  final String fcmToken;

  CreateUser(this.fcmToken);
  @override
  List<Object?> get props => [fcmToken];
}

class Login extends AuthEvent {
  final String ticket;

  Login(this.ticket);
  @override
  List<Object?> get props => [ticket];
}

class AutoLogin extends AuthEvent {}

class Logout extends AuthEvent {}
