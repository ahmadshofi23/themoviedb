class CastEntity {
  final String name;
  final String character;
  final String profilePath;

  CastEntity({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  String get profileUrl => 'https://image.tmdb.org/t/p/w185$profilePath';
}
