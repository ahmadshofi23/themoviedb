import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? name;
  final String? avatarUrl;
  final String? joinDate;
  final bool isGuest;
  final List<ProfileHistoryMovieEntity> lastWatched;

  const ProfileEntity({
    this.name,
    this.avatarUrl,
    this.joinDate,
    required this.isGuest,
    required this.lastWatched,
  });

  factory ProfileEntity.guest() => const ProfileEntity(
    name: "Tamu TMDB",
    avatarUrl: null,
    joinDate: null,
    isGuest: true,
    lastWatched: [],
  );

  @override
  List<Object?> get props => [name, avatarUrl, joinDate, isGuest, lastWatched];
}

class ProfileHistoryMovieEntity extends Equatable {
  final String imageUrl;
  final String label;

  const ProfileHistoryMovieEntity({
    required this.imageUrl,
    required this.label,
  });

  @override
  List<Object?> get props => [imageUrl, label];
}
