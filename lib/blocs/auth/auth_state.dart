part of 'auth_bloc.dart';

abstract class AuthState extends BlocState {
  const AuthState({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

class AuthInit extends AuthState {}

// Register
class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

// Login
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final User user;

  const LoginSuccess(this.user);
}

// Logout
class LogoutSuccess extends AuthState {}

class AuthFailed extends AuthState {
  const AuthFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}
