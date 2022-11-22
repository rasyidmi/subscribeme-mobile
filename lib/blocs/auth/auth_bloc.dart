import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
    // on<AutoLogin>(_onAutoLogin);
  }

  Future<void> _onRegisterHandler(
      Register event, Emitter<AuthState> emit) async {
    emit(RegisterLoading());
    try {
      await _authRepository.register(event.data);
      emit(RegisterSuccess());
    } on firebase_auth.FirebaseAuthException catch (f) {
      ResponseStatus? status;
      String? message;
      if (f.code == 'email-already-in-use') {
        status = ResponseStatus.duplicateData;
        message = 'Email telah digunakan';
      } else if (f.code == 'invalid-email') {
        status = ResponseStatus.failed;
        message = 'Format email salah';
      } else if (f.code == 'weak-password') {
        status = ResponseStatus.failed;
        message = 'Password terlalu lemah';
      } else {
        status = ResponseStatus.failed;
        message = 'Terjadi kesalahan, silahkan coba lagi';
      }
      emit(
        AuthFailed(
          status: status,
          message: message,
        ),
      );
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
    } on firebase_auth.FirebaseAuthException catch (f) {
      ResponseStatus? status;
      String? message;
      if (f.code == 'user-not-found') {
        status = ResponseStatus.failed;
        message = 'Pengguna tidak ditemukan';
      } else if (f.code == 'invalid-email') {
        status = ResponseStatus.failed;
        message = 'Format email salah';
      } else if (f.code == 'wrong-password') {
        status = ResponseStatus.failed;
        message = 'Kata sandi salah';
      } else {
        status = ResponseStatus.failed;
        message = 'Terjadi kesalahan, silahkan coba lagi';
      }
      emit(
        AuthFailed(
          status: status,
          message: message,
        ),
      );
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

  // Future<void> _onAutoLogin(AutoLogin event, Emitter<AuthState> emit) async {
  //   final user = await _authRepository.doAutoLogin();
  //   if (user != null) {
  //     emit(LoginSuccess(user));
  //   } else {
  //     emit(AuthFailed());
  //   }
  // }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(LogoutSuccess());
  }
}
