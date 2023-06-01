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

// Create user.
class CreateUserSuccess extends AuthState {}

class CreateUserLoading extends AuthState {}

class CreateUserFailed extends AuthState {
  const CreateUserFailed({
    ResponseStatus? status,
    String? message,
  }) : super(
          status: status,
          message: message,
        );
}

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
