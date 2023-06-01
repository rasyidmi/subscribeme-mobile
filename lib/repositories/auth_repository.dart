import 'package:subscribeme_mobile/api/auth_api.dart';
import 'package:subscribeme_mobile/models/user.dart';

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository(this._authApi);

  Future<bool> creteUser(String fcmToken) async {
    return _authApi.createUser(fcmToken);
  }

  Future<User> login(String ticket) async {
    return _authApi.login(ticket);
  }

  Future<User?> doAutoLogin() async {
    return _authApi.tryAutoLogin();
  }

  Future<void> logout() async {
    await _authApi.logout();
  }
}
