import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/user.dart';
import 'package:subscribeme_mobile/services/secure_storage.dart';

class AuthApi {
  firebase_auth.User? _currentUser;
  final LocalStorageService _storageService = LocalStorageService();
  final _authPath = '/user';

  Future<bool> register(Map<String, dynamic> data) async {
    Map<String, String> newUserData = {
      "name": data['name'],
      "password": data['password'],
      "email": data['email'],
      "role": data['role'],
    };

    final response = await RequestHelper.postWithoutToken(
      '$_authPath/register',
      newUserData,
    );
    if (response.status == ResponseStatus.success) {
      return true;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  Future<User> signIn(Map<String, dynamic> data) async {
    Map<String, String> signInData = {
      "email": data['email'],
      "password": data['password']
    };
    final response = await RequestHelper.postWithoutToken(
      '$_authPath/login',
      signInData,
    );
    if (response.status == ResponseStatus.success) {
      // Store token in local storage.
      await _storageService.writeSecureData(
          "accessToken", response.data!["data"]["accessToken"]);
      await _storageService.writeSecureData(
          "refreshToken", response.data!["data"]["refreshToken"]);
      log(response.data!["data"]["userData"].toString());
      User user = User.fromJson(response.data!["data"]["userData"]);
      return user;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  Future<User?> tryAutoLogin() async {
    String? accessToken = await getAccessToken();
    if (accessToken == null || accessToken == "") return null;
    final response = await RequestHelper.post('$_authPath/autoLogin', {});
    if (response.status == ResponseStatus.success) {
      // Store token in local storage.
      await _storageService.writeSecureData(
          "accessToken", response.data!["data"]["accessToken"]);
      await _storageService.writeSecureData(
          "refreshToken", response.data!["data"]["refreshToken"]);
      log(response.data!["data"]["userData"].toString());
      User user = User.fromJson(response.data!["data"]["userData"]);
      return user;
    } else if (response.status == ResponseStatus.unauthorized) {
      return await _refreshToken();
    } else {
      throw SubsHttpException(response.status, null);
    }
  }

  Future<User?> _refreshToken() async {
    final response = await RequestHelper.refreshToken();
    if (response.status == ResponseStatus.success) {
      // Store token in local storage.
      await _storageService.writeSecureData(
          "accessToken", response.data!["data"]["accessToken"]);
      await _storageService.writeSecureData(
          "refreshToken", response.data!["data"]["refreshToken"]);
      User user = User.fromJson(response.data!["data"]["userData"]);
      return user;
    } else if (response.status == ResponseStatus.unauthorized) {
      return null;
    } else {
      throw SubsHttpException(response.status, null);
    }
  }

  Future<void> logout() async {
    await _storageService.writeSecureData("accessToken", "");
    await _storageService.writeSecureData("refreshToken", "");
  }

  Future<String?> getAccessToken() async {
    return await _storageService.readSecureData("accessToken");
  }

  Future<String?> getRefreshToken() async {
    return await _storageService.readSecureData("refreshToken");
  }
}
