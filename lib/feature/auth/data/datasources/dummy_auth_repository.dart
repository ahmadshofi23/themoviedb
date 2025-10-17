import 'package:themoviedb/feature/auth/domain/entity/auth_entity.dart';
import 'package:themoviedb/feature/auth/domain/repository/auth_repository.dart';

class DummyAuthRepository implements AuthRepository {
  AuthEntity _auth = AuthEntity.guest();

  @override
  Future<AuthEntity> getAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _auth;
  }

  @override
  Future<AuthEntity> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = AuthEntity(
      name: "John Doe",
      email: email,
      avatarUrl: "https://i.pravatar.cc/150?img=3",
      isGuest: false,
    );
    return _auth;
  }

  @override
  Future<AuthEntity> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _auth = AuthEntity.guest();
    return _auth;
  }
}
