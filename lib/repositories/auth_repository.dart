import 'package:subscribeme_mobile/api/auth_api.dart';
import 'package:subscribeme_mobile/models/user.dart';

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository(this._authApi);

  Future<bool> register(Map<String, dynamic> body) async {
    return _authApi.register(body);
  }

  Future<User> signIn(Map<String, dynamic> data) async {
    return _authApi.signIn(data);
  }

  // Future<User?> doAutoLogin() async {
  //   return _authApi.tryAutoLogin();
  // }

  Future<void> logout() async {
    return await _authApi.logout();
  }
}
