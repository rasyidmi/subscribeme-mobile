import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:subscribeme_mobile/api/api_constants.dart';
import 'package:subscribeme_mobile/api/auth_api.dart';
import 'package:subscribeme_mobile/commons/arguments/http_exception.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';

class RequestHelper {
  static final apiPath = baseUrl;

  static Future<HttpResponse> get(String path) async {
    final token = await locator<AuthApi>().getToken();
    // Check token is expired or not.
    if (RequestHelper._isTokenExpired(token!)) {
      throw SubsHttpException(ResponseStatus.tokenExpire, null);
    }
    final urlPath = '$apiPath$path';

    final response = await http.get(
      Uri.parse(urlPath),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(response.statusCode, decodedBody, "GET", urlPath);
  }

  static Future<HttpResponse> getWithoutToken(
      String path, Map<String, dynamic>? body) async {
    final urlPath = '$apiPath$path';

    final response = await http.get(
      Uri.parse(urlPath),
      headers: {'Content-Type': 'application/json'},
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(response.statusCode, decodedBody, "GET", urlPath);
  }

  static Future<HttpResponse> delete(String path) async {
    final token = await locator<AuthApi>().getToken();
    final urlPath = '$apiPath$path';

    final response = await http.delete(
      Uri.parse(urlPath),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decodedBody = json.decode(response.body);
    return _responseHandler(
        response.statusCode, decodedBody, "DELETE", urlPath);
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

    return _responseHandler(response.statusCode, decodedBody, "POST", urlPath);
  }

  static Future<HttpResponse> post(
      String path, Map<String, dynamic>? body) async {
    final token = await locator<AuthApi>().getToken();
    // Check token is expired or not.
    if (RequestHelper._isTokenExpired(token!)) {
      throw SubsHttpException(ResponseStatus.tokenExpire, null);
    }
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

    return _responseHandler(response.statusCode, decodedBody, "POST", urlPath);
  }

  static Future<HttpResponse> put(
      String path, Map<String, dynamic>? body) async {
    final token = await locator<AuthApi>().getToken();
    final urlPath = '$apiPath$path';

    // Check token is expired or not.
    if (RequestHelper._isTokenExpired(token!)) {
      throw SubsHttpException(ResponseStatus.tokenExpire, null);
    }

    final response = await http.put(
      Uri.parse(urlPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encoder.convert(body),
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(response.statusCode, decodedBody, "POST", urlPath);
  }

  static Future<HttpResponse> _responseHandler(
    int statusCode,
    dynamic decodedData,
    String method,
    String url,
  ) async {
    late ResponseStatus status;
    if (statusCode >= 200 && statusCode < 300) {
      // Success.
      status = ResponseStatus.success;
    } else if (decodedData["data"].toString().contains('duplicate')) {
      status = ResponseStatus.duplicateData;
    } else if (statusCode == 401) {
      // Unauthorized.
      status = ResponseStatus.unauthorized;
    } else if (statusCode == 408) {
      status = ResponseStatus.timeout;
    } else {
      status = ResponseStatus.failed;
    }

    return HttpResponse(status: status, data: decodedData);
  }

  static bool _isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}

class HttpResponse {
  final ResponseStatus status;
  final Map<String, dynamic>? data;

  HttpResponse({required this.status, this.data});
}
