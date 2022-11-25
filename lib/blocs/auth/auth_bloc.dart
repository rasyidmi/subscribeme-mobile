import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/bloc_state.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/user.dart';
import 'package:subscribeme_mobile/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInit()) {
    on<Register>(_onRegisterHandler);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<AutoLogin>(_onAutoLogin);
  }

  Future<void> _onRegisterHandler(
      Register event, Emitter<AuthState> emit) async {
    emit(RegisterLoading());
    try {
      await _authRepository.register(event.data);
      emit(RegisterSuccess());
    } on SubsHttpException catch (e) {
      emit(AuthFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const AuthFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.signIn(event.data);
      emit(LoginSuccess(user));
    } on SubsHttpException catch (e) {
      emit(AuthFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const AuthFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onAutoLogin(AutoLogin event, Emitter<AuthState> emit) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.doAutoLogin();
      if (user != null) {
        emit(LoginSuccess(user));
      } else if (user == null) {
        emit(const AuthFailed(status: ResponseStatus.unauthorized));
      }
    } on SubsHttpException catch (e) {
      emit(AuthFailed(
        status: e.status,
        message: e.message,
      ));
    } catch (f) {
      log('ERROR: ' + f.toString());
      emit(const AuthFailed(status: ResponseStatus.maintenance));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(LogoutSuccess());
  }
}
