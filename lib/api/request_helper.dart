import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:subscribeme_mobile/api/api_constants.dart';
import 'package:subscribeme_mobile/api/auth_api.dart';
import 'package:subscribeme_mobile/commons/constants/response_status.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';
import 'package:subscribeme_mobile/services/secure_storage.dart';

class RequestHelper {
  static final apiPath = baseUrl;
  final LocalStorageService _storageService = LocalStorageService(); 

  static Future<HttpResponse> get(String path) async {
    final token = await locator<AuthApi>().getIDToken();
    final urlPath = '$apiPath$path';

    final response = await http.get(
      Uri.parse(urlPath),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(response.statusCode, decodedBody);
  }

  static Future<HttpResponse> getWithoutToken(
      String path, Map<String, dynamic>? body) async {
    final urlPath = '$apiPath$path';

    final response = await http.get(
      Uri.parse(urlPath),
      headers: {'Content-Type': 'application/json'},
    );

    final decodedBody = json.decode(response.body);

    return _responseHandler(response.statusCode, decodedBody);
  }

  static Future<HttpResponse> delete(String path) async {
    final token = await locator<AuthApi>().getIDToken();
    final urlPath = '$apiPath$path';

    final response = await http.delete(Uri.parse(urlPath),
        headers: {'Authorization': 'Bearer $token'});

    final decodedBody = json.decode(response.body);
    return _responseHandler(response.statusCode, decodedBody);
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

    return _responseHandler(response.statusCode, decodedBody);
  }

  static Future<HttpResponse> post(
      String path, Map<String, dynamic>? body) async {
    final token = await locator<AuthApi>().getIDToken();
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

    return _responseHandler(response.statusCode, decodedBody);
  }

  static HttpResponse _responseHandler(int statusCode, dynamic data) {
    late ResponseStatus status;
    if (statusCode == 200) {
      status = ResponseStatus.success;
    } else if (data["data"].toString().contains('duplicate')) {
      status = ResponseStatus.duplicateData;
    } else if (statusCode == 401) {
      status = ResponseStatus.unauthorized;
    } else if (statusCode == 408) {
      status = ResponseStatus.timeout;
    } else {
      status = ResponseStatus.failed;
    }

    return HttpResponse(status: status, data: data);
  }
}

class HttpResponse {
  final ResponseStatus status;
  final Map<String, dynamic>? data;

  HttpResponse({required this.status, this.data});
}
