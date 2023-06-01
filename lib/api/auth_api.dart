import 'dart:developer';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:subscribeme_mobile/api/request_helper.dart';
import 'package:subscribeme_mobile/api/api_constants.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/models/user.dart';
import 'package:subscribeme_mobile/services/secure_storage.dart';

class AuthApi {
  final LocalStorageService _storageService = LocalStorageService();

  Future<User> login(String ticket) async {
    Map<String, String> body = {
      "ticket": ticket,
      "service_url": serviceUrl!,
    };

    final response = await RequestHelper.postWithoutToken('/login', body);
    if (response.status == ResponseStatus.success) {
      // Store token in local storage.
      await _storageService.writeSecureData(
          "token", response.data!["data"]["token"]);
      final decodedJwt = JwtDecoder.decode(response.data!["data"]["token"]);
      decodedJwt["is_user_exist"] = response.data!["data"]["is_user_exists"];
      final user = User.fromJson(decodedJwt);
      return user;
    } else if (response.status == ResponseStatus.unauthorized) {
      throw SubsHttpException(response.status, response.data!["errors"][0]);
    } else {
      throw SubsHttpException(response.status, response.data!["message"]);
    }
  }

  Future<bool> createUser(String fcmToken) async {
    Map<String, String> body = {"fcm_token": fcmToken};

    final response = await RequestHelper.post(
      '/user',
      body,
    );
    if (response.status == ResponseStatus.success) {
      // Store new token in local storage.
      await _storageService.writeSecureData(
          "token", response.data!["data"]["token"]);
      return true;
    } else {
      throw SubsHttpException(response.status, response.data!["data"]);
    }
  }

  // Future<User> signIn(Map<String, dynamic> data) async {
  //   Map<String, String> signInData = {
  //     "email": data['email'],
  //     "password": data['password']
  //   };
  //   final response = await RequestHelper.postWithoutToken(
  //     '$_authPath/login',
  //     signInData,
  //   );
  //   if (response.status == ResponseStatus.success) {
  //     // Store token in local storage.
  //     await _storageService.writeSecureData(
  //         "accessToken", response.data!["data"]["accessToken"]);
  //     await _storageService.writeSecureData(
  //         "refreshToken", response.data!["data"]["refreshToken"]);
  //     log(response.data!["data"]["userData"].toString());
  //     User user = User.fromJson(response.data!["data"]["userData"]);
  //     return user;
  //   } else {
  //     throw SubsHttpException(response.status, response.data!["data"]);
  //   }
  // }

  Future<User?> tryAutoLogin() async {
    String? token = await getToken();
    if (token == null || token == "") return null;
    // Check token expired data.
    if (!JwtDecoder.isExpired(token)) {
      log('Token pengguna: $token');
      final decodedJwt = JwtDecoder.decode(token);
      final user = User.fromJson(decodedJwt);
      return user;
    }
    return null;
  }

  Future<void> logout() async {
    await _storageService.writeSecureData("token", "");
  }

  Future<String?> getToken() async {
    return await _storageService.readSecureData("token");
  }

  Future<String?> getRefreshToken() async {
    return await _storageService.readSecureData("refreshToken");
  }
}
