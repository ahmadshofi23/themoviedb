import 'package:themoviedb/feature/auth/domain/entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileHistoryMovieEntity> getProfile();
}
