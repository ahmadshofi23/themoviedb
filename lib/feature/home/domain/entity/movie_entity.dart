class MovieEntity {
  final int id;
  final String title;
  final String posterPath;
  final double rating;
  final String overview;
  final String media_type;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.overview,
    required this.media_type,
  });

  String get fullPosterUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
}
