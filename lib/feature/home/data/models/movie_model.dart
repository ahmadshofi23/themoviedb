import 'package:themoviedb/feature/home/domain/entity/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.rating,
    required super.overview,
    required super.media_type,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? json['original_title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      overview: json['overview'] ?? json['title'],
      media_type: json['media_type'] ?? '',
    );
  }
}
