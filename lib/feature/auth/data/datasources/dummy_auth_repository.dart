import 'package:shared_preferences/shared_preferences.dart';
import 'package:themoviedb/feature/auth/domain/entity/auth_entity.dart';
import 'package:themoviedb/feature/auth/domain/repository/auth_repository.dart';

class DummyAuthRepository implements AuthRepository {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyEmail = 'user_email';
  static const _keyName = 'user_name';
  static const _keyAvatar = 'user_avatar';

  AuthEntity _auth = AuthEntity.guest();

  @override
  Future<AuthEntity> getAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      final email = prefs.getString(_keyEmail) ?? 'guest@example.com';
      final name = prefs.getString(_keyName) ?? 'Guest';
      final avatar =
          prefs.getString(_keyAvatar) ?? 'https://i.pravatar.cc/150?img=3';
      _auth = AuthEntity(
        name: name,
        email: email,
        avatarUrl: avatar,
        isGuest: false,
      );
    } else {
      _auth = AuthEntity.guest();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return _auth;
  }

  @override
  Future<AuthEntity> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // contoh user dummy
    final newUser = AuthEntity(
      name: "John Doe",
      email: email,
      avatarUrl: "https://i.pravatar.cc/150?img=3",
      isGuest: false,
    );

    // simpan ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyName, newUser.name);
    await prefs.setString(_keyAvatar, newUser.avatarUrl ?? '');

    _auth = newUser;
    return _auth;
  }

  @override
  Future<AuthEntity> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _auth = AuthEntity.guest();
    return _auth;
  }
}
