class CrewEntity {
  final String name;
  final String profilePath;
  final String department;

  CrewEntity({
    required this.name,
    required this.profilePath,
    required this.department,
  });

  String get profileUrl => 'https://image.tmdb.org/t/p/w185$profilePath';
}
