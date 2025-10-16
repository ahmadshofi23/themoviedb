import 'package:themoviedb/feature/home/domain/entity/cast_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/crew_entity.dart';

class MovieDetailEntity {
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
  final List<CrewEntity> crew;

  MovieDetailEntity({
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
    required this.crew,
  });

  String get fullPosterUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropUrl => 'https://image.tmdb.org/t/p/w780$backdropPath';
}
