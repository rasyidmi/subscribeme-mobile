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
      log('Token pengguna: ${response.data!["data"]["token"]}');
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
    await _storageService.deleteSecureData("token");
  }

  Future<String?> getToken() async {
    return await _storageService.readSecureData("token");
  }

  Future<bool> updateFcmToken(String fcmToken) async {
    Map<String, String> body = {"fcm_token": fcmToken};
    final response = await RequestHelper.put("/user", body);
    return response.status == ResponseStatus.success;
  }
}
