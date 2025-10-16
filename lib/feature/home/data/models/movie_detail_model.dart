import 'package:themoviedb/feature/home/domain/entity/cast_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/crew_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_detail_entity.dart';

class MovieDetailModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<String> genres;
  final String? status;
  final String originalLanguage;
  final double budget;
  final double revenue;
  final String? director;
  final List<String> writers;
  final List<String> characters;
  final List<CastEntity> casts;
  final List<CrewEntity> crews;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    this.status,
    required this.originalLanguage,
    required this.budget,
    required this.revenue,
    this.director,
    required this.writers,
    required this.characters,
    required this.casts,
    required this.crews,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    final credits = json['credits'] ?? {};
    final crew = (credits['crew'] as List?) ?? [];
    final castList = (credits['cast'] as List?) ?? [];

    final director =
        crew.firstWhere(
          (c) => c['job'] == 'Director',
          orElse: () => {'name': null},
        )['name'];

    final writers =
        crew
            .where(
              (c) =>
                  c['department'] == 'Writing' ||
                  c['job'] == 'Screenplay' ||
                  c['job'] == 'Writer',
            )
            .map<String>((c) => c['name'].toString())
            .toList();

    final casts =
        castList.take(10).map<CastEntity>((c) {
          return CastEntity(
            name: c['name'] ?? '',
            character: c['character'] ?? '',
            profilePath: c['profile_path'] ?? '',
          );
        }).toList();

    final crews =
        crew.take(10).map<CrewEntity>((c) {
          return CrewEntity(
            name: c['name'] ?? '',
            department: c['department'] ?? '',
            profilePath: c['profile_path'] ?? '',
          );
        }).toList();

    return MovieDetailModel(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      genres:
          (json['genres'] as List)
              .map<String>((g) => g['name'].toString())
              .toList(),
      status: json['status'],
      originalLanguage: json['original_language'] ?? '',
      budget: (json['budget'] ?? 0).toDouble(),
      revenue: (json['revenue'] ?? 0).toDouble(),
      director: director,
      writers: writers,
      characters: casts.map((c) => c.character).toList(),
      casts: casts,
      crews: crews,
    );
  }

  MovieDetailEntity toEntity() {
    return MovieDetailEntity(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      runtime: runtime,
      genres: genres,
      status: status,
      originalLanguage: originalLanguage,
      budget: budget,
      revenue: revenue,
      director: director,
      writers: writers,
      characters: characters,
      casts: casts,
      crew: crews,
    );
  }
}
