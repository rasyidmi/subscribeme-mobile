import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/commons/constants/role.dart';
import 'package:subscribeme_mobile/models/user.dart';

class AuthApi {
  firebase_auth.User? _currentUser;
  final _authPath = '/user';

  Future<bool> register(Map<String, dynamic> data) async {
    User newUser = User(
      name: data['name'],
      email: data['email'],
      role: data['role'] == 'admin' ? Role.admin : Role.user,
      avatar: data['avatar'],
    );

    final response = await RequestHelper.postWithoutToken(
      '$_authPath/register',
      newUser.toJson(),
    );
    if (response.status == ResponseStatus.success) {
      return true;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  Future<User> signIn(Map<String, dynamic> data) async {
    final userCredential =
        await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    );
    final response = await RequestHelper.getWithoutToken(
      '$_authPath/${userCredential.user!.uid}',
      null,
    );
    if (response.status == ResponseStatus.success) {
      User user = User.fromJson(response.data!['data']);

      return user;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  // Future<User?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     // Create a new credential
  //     final credential = firebase_auth.GoogleAuthProvider.credential(
  //       accessToken: googleAuth!.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Once signed in, return the UserCredential
  //     final userCred = await firebase_auth.FirebaseAuth.instance
  //         .signInWithCredential(credential);

  //     _currentUser = userCred.user;

  //     User user = User(
  //       id: _currentUser!.uid,
  //       name: _currentUser!.displayName!,
  //       email: _currentUser!.email!,
  //       photoUrl: _currentUser!.photoURL,
  //     );

  //     final token = await _currentUser!.getIdToken(true);
  //     log('TOKEN: ' + token);

  //     return user;
  //   } catch (e) {
  //     log('Error: ' + e.toString());
  //     return null;
  //   }

  //   // final response = await RequestHelper.post(
  //   //   _login,
  //   //   user.toJson(),
  //   // );

  //   // if (response.status) {
  //   //   return user;
  //   // } else {
  //   //   // Clear data
  //   //   await firebase_auth.FirebaseAuth.instance.signOut();
  //   //   _currentUser = null;
  //   //   return null;
  //   // }
  // }

  // Future<User?> tryAutoLogin() async {
  //   if (_isUserLoggedIn()) {
  //     _currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
  //     User user = User(
  //       id: _currentUser!.uid,
  //       name: _currentUser!.displayName!,
  //       email: _currentUser!.email!,
  //       photoUrl: _currentUser!.photoURL,
  //     );
  //     return user;
  //   }
  // return null;
  // }

  Future<void> logout() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    _currentUser = null;
  }

  bool _isUserLoggedIn() {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<String> getIDToken() async {
    final token = await _currentUser!.getIdToken();
    return token;
  }
}
