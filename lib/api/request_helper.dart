import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:subscribeme_mobile/api/api_constants.dart';
import 'package:subscribeme_mobile/api/auth_api.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';
import 'package:subscribeme_mobile/services/secure_storage.dart';

class RequestHelper {
  static final apiPath = baseUrl;
  static final LocalStorageService _storageService = LocalStorageService();

  static Future<HttpResponse> get(String path) async {
    final token = await locator<AuthApi>().getAccessToken();
    final urlPath = '$apiPath$path';

    final response = await http.get(
      Uri.parse(urlPath),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(
        response.statusCode, decodedBody, null, "GET", urlPath);
  }

  static Future<HttpResponse> getWithoutToken(
      String path, Map<String, dynamic>? body) async {
    final urlPath = '$apiPath$path';

    final response = await http.get(
      Uri.parse(urlPath),
      headers: {'Content-Type': 'application/json'},
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(
        response.statusCode, decodedBody, null, "GET", urlPath);
  }

  static Future<HttpResponse> delete(String path) async {
    final token = await locator<AuthApi>().getAccessToken();
    final urlPath = '$apiPath$path';

    final response = await http.delete(
      Uri.parse(urlPath),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decodedBody = json.decode(response.body);
    return _responseHandler(
        response.statusCode, decodedBody, null, "DELETE", urlPath);
  }

  static Future<HttpResponse> postWithoutToken(
      String path, Map<String, dynamic>? body) async {
    final urlPath = '$apiPath$path';

    final response = await http.post(
      Uri.parse(urlPath),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encoder.convert(body),
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(
        response.statusCode, decodedBody, body, "POST", urlPath);
  }

  static Future<HttpResponse> post(
      String path, Map<String, dynamic>? body) async {
    final token = await locator<AuthApi>().getAccessToken();
    final urlPath = '$apiPath$path';

    final response = await http.post(
      Uri.parse(urlPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encoder.convert(body),
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(
        response.statusCode, decodedBody, body, "POST", urlPath);
  }

  static Future<HttpResponse> _responseHandler(
    int statusCode,
    dynamic decodedData,
    Map<String, dynamic>? data,
    String method,
    String url,
  ) async {
    late ResponseStatus status;
    if (statusCode >= 200 && statusCode < 300) {
      status = ResponseStatus.success;
    } else if (decodedData["data"].toString().contains('duplicate')) {
      status = ResponseStatus.duplicateData;
    } else if (statusCode == 401) {
      return await _handleExpiredToken(url, data, method);
    } else if (statusCode == 408) {
      status = ResponseStatus.timeout;
    } else {
      status = ResponseStatus.failed;
    }

    return HttpResponse(status: status, data: decodedData);
  }

  static Future<HttpResponse> _handleExpiredToken(
    String url,
    Map<String, dynamic>? data,
    String method,
  ) async {
    final token = await locator<AuthApi>().getRefreshToken();
    final urlPath = '$apiPath/user/refresh';

    final response = await http.post(
      Uri.parse(urlPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    // Both token expired.
    if (response.statusCode != 200) {
      return HttpResponse(status: ResponseStatus.tokenExpire, data: null);
    }
    final decodedBody = json.decode(response.body);
    final newAccessToken = decodedBody!["data"]["accessToken"];
    // Store token in local storage.
    await _storageService.writeSecureData("accessToken", newAccessToken);
    await _storageService.writeSecureData(
        "refreshToken", decodedBody!["data"]["refreshToken"]);
    // Hit the API again.
    http.Response newResponse;
    final parsedUrl = Uri.parse(url);
    if (method == "GET") {
      newResponse = await http.get(
        parsedUrl,
        headers: {'Authorization': 'Bearer $newAccessToken'},
      );
    } else if (method == "POST") {
      newResponse = await http.post(
        parsedUrl,
        headers: {'Authorization': 'Bearer $newAccessToken'},
        body: json.encoder.convert(data),
      );
    } else {
      newResponse = await http.delete(
        parsedUrl,
        headers: {'Authorization': 'Bearer $newAccessToken'},
        body: json.encoder.convert(data),
      );
    }
    final newDecodedBody = json.decode(newResponse.body);

    return _responseHandler(
        newResponse.statusCode, newDecodedBody, data, method, url);
  }
}

class HttpResponse {
  final ResponseStatus status;
  final Map<String, dynamic>? data;

  HttpResponse({required this.status, this.data});
}
