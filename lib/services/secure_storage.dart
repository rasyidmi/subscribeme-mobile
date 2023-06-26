import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    var data = await _secureStorage.read(key: key);
    return data;
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }
}
