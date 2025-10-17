import 'package:themoviedb/feature/auth/domain/entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> getAuthStatus();
  Future<AuthEntity> login(String username, String password);
  Future<AuthEntity> logout();
}
